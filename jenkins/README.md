# jenkins pipeline


```
    // 配置机密文本、用户名和密码
stage('Deploy'){
      steps {
       withCredentials([usernamePassword(credentialsId: 'aliyun_oss_upload', passwordVariable: 'aliyun_sceret', usernameVariable: 'aliyun_key')]) {
       sh '~/ossutil config -e ${endpoint} -i ${aliyun_key} -k ${aliyun_sceret};~/ossutil cp -r -f dist "oss://${name}"'
      }
    }
}
// 注：需先在jenkins添加用户凭据
```


```
// 配置局部变量
stage('Deploy'){
steps {
withEnv(['service=java']){
    echo '$service'
}}
}
.....
```

```
// 拉取代码
stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/${branch}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '3', url: 'ssh://git@giturl/javacode.git']]])
      }
    }

```


```
// 定义构建完成后执行动作
post {
        success {
            echo '构建成功'
        }
        failure {
            echo '构建失败'
        }
        unstable {
            echo '该任务被标记为不稳定任务'
        }
        aborted {
            echo '该任务被终止' 
        }
    }
```

```
// 按条件判断
stage('Build'){
      steps {
        script { 
          if ("${gitrepo}" == "java") {
                             echo "java"
          }         
          else if ("${gitrepo}" == "python"){
             echo "python"
          } else {
             echo "nodejs"
           }
          } 
      }
    }
```

```
// 获取命令返回值
stage('Push'){
      steps {
        script{
        def pid = sh returnStatus: true, script: " ps -ef|grep tomcat|awk '{print \$2}'"
        echo '$pid'
      }   
      }
    }
```
