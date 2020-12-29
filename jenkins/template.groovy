pipeline {
agent any
options {
    durabilityHint 'PERFORMANCE_OPTIMIZED'
    timeout(time:5, unit: 'MINUTES')
    timestamps()
    skipStagesAfterUnstable()
    // retry(2)
    skipDefaultCheckout true
    buildDiscarder logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '10', numToKeepStr: '5')
}
stages {
    stage('拉取代码') {
        steps {
            echo '正在拉取代码...'
            script {
                try {
                    checkout([$class: 'GitSCM', branches: [[name: 'v1-0-8-apix-20190531']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', noTags: true, shallow: true, depth: 1, honorRefspec:true]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '7e1f82d8-c808-4555-8c82-2a67f6cbcded',refspec: '+refs/heads/v1-0-8-apix-20190531:refs/remotes/origin/v1-0-8-apix-20190531', url: 'git@gitlab.test.cn:app/forseti.git']]])
                } catch(Exception err) {
                    echo err.getMessage()
                    echo err.toString()
                    unstable '拉取代码失败'
                    warnError('拉取代码失败信息回调失败') {
                        retry(5){
                            httpRequest acceptType: 'APPLICATION_JSON', consoleLogResponseBody: true, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"step\":\"pull\",\"id\":\"${JOB_NAME}\",\"build_number\":\"${BUILD_NUMBER}\"}", timeout: 5, url: 'http://127.0.0.1:8088/api/v1/job_finish', validResponseCodes: '200', validResponseContent: 'ok'
                        }
                    }
                }
            }
        }
    }
    stage('构建') {
        options {
            timeout(time:3, unit: 'MINUTES')
        }
        steps {
            echo '正在构建....'
            script {
                try {
                    sh 'touch forseti-api.properties'
                    sh 'mvn -B clean install -DskipTests -U'
                } catch (Exception err) {
                    echo err.getMessage()
                    echo err.toString()
                    unstable '构建失败'
                    warnError('构建失败信息回调失败') {
                        retry(5) {
                            httpRequest acceptType: 'APPLICATION_JSON', consoleLogResponseBody: true, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"step\":\"build\",\"id\":\"${JOB_NAME}\",\"build_number\":\"${BUILD_NUMBER}\"}", timeout: 5, url: 'http://127.0.0.1:8088/api/v1/job_finish', validResponseCodes: '200', validResponseContent: 'ok'
                        }
                    }
                }
            }
        }
    }
    stage('依赖性检查') {
        steps {
            echo '正在生成依赖性检查信息...'
            script {
                try {
                    sh 'mvn -B dependency:tree > dependency.log'
                } catch(Exception err) {
                    echo err.getMessage()
                    echo err.toString()
                    unstable '依赖性检查失败'
                    warnError('依赖性检查失败信息回调失败') {
                        retry(5) {
                            httpRequest acceptType: 'APPLICATION_JSON', consoleLogResponseBody: true, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"step\":\"check\",\"id\":\"${JOB_NAME}\",\"build_number\":\"${BUILD_NUMBER}\"}", timeout: 5, url: 'http://127.0.0.1:8088/api/v1/job_finish', validResponseCodes: '200', validResponseContent: 'ok'
                        }
                    }
                }
            }
        }
    }
    stage('返回依赖性检查文件') {
        steps {
            echo '正在返回依赖性检查文件给erebsu应用...'
            script {
                try {
                    retry(5) {
                        httpRequest acceptType: 'APPLICATION_JSON', consoleLogResponseBody: true, contentType: 'APPLICATION_OCTETSTREAM', customHeaders: [[maskValue: false, name: 'Content-Disposition', value: 'id=dependency.log']], httpMode: 'POST', ignoreSslErrors: true, multipartName: 'file', requestBody: "{\"id\":\"${JOB_NAME}\"}", timeout: 5, uploadFile: 'dependency.log', url: 'http://127.0.0.1:8088/api/v1/job_data_update', validResponseCodes: '200', validResponseContent: 'ok'
                    }
                } catch(Exception err) {
                    echo err.getMessage()
                    echo err.toString()
                    unstable '依赖性检查文件返回给erebus失败'
                    warnError('依赖性检查文件返回给erebus失败信息回调失败') {
                        retry(5) {
                            httpRequest acceptType: 'APPLICATION_JSON', consoleLogResponseBody: true, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"step\":\"callback\",\"id\":\"${JOB_NAME}\",\"build_number\":\"${BUILD_NUMBER}\"}", timeout: 5, url: 'http://127.0.0.1:8088/api/v1/job_finish', validResponseCodes: '200', validResponseContent: 'ok'
                        }
                    }
                }
            }
        }
    }
    stage('完成') {
        steps {
            echo '依赖性检查完成，正在返回完成信息...'
            retry(5) {
                httpRequest contentType: 'APPLICATION_OCTETSTREAM', customHeaders: [[maskValue: false, name: 'Content-type', value: 'application/json'], [maskValue: false, name: 'Accept', value: 'application/json']], httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"id\":\"${JOB_NAME}\",\"build_number\":\"${BUILD_NUMBER}\"}", responseHandle: 'NONE', timeout: 5, url: 'http://127.0.0.1:8088/api/v1/job_finish', validResponseContent: 'ok'
            }
        }
    }
}
post {
    always {
        cleanWs()
    }
}
}