pipeline {
    agent {
        label 'master'
    }
    tools {
        maven 'Maven'
    }
    // NEXUS_VERSION：在这里，我们必须提及Nexus的确切版本，可以是nexus2或nexus3。在我们的情况下，它是的最新版本nexus3。
    // NEXUS_PROTOCOL：对于本指南，我们使用了HTTP协议，但是，在正式生产的情况下，您将必须使用HTTPS。
    // NEXUS_URL：添加您的IP地址和端口号，以运行Nexus。确保您添加的Nexus实例详细信息没有提及协议，例如https或http。
    // NEXUS_CREDENTIAL_ID：输入您先前在Jenkins中创建的用户ID，在本例中为 nexus-user-credentials。
    environment {
        NEXUS_VERSION = 'nexus3'
        NEXUS_PROTOCOL = 'http'
        NEXUS_URL = 'you-ip-addr-here:8081'
        NEXUS_REPOSITORY = 'maven-nexus-repo'
        NEXUS_CREDENTIAL_ID = 'nexus-user-credentials'
    }
    stages {
        stage('Clone code from VCS') {
            steps {
                script {
                    git 'https://github.com/javaee/cargotracker.git'
                }
            }
        }
        stage('Maven Build') {
            steps {
                script {
                    sh 'mvn package -DskipTests=true'
                }
            }
        }
        stage('Publish to Nexus Repository Manager') {
            steps {
                script {
                    pom = readMavenPom file: 'pom.xml'
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}")
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path
                    artifactExists = fileExists artifactPath
                    if (artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}"
                        nexusArtifactUploader(
                        nexusVersion: NEXUS_VERSION,
                        protocol: NEXUS_PROTOCOL,
                        nexusUrl: NEXUS_URL,
                        groupId: pom.groupId,
                        version: pom.version,
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIAL_ID,
                        artifacts: [
                        [artifactId: pom.artifactId,
                        classifier: '',
                        file: artifactPath,
                        type: pom.packaging],
                        [artifactId: pom.artifactId,
                        classifier: '',
                        file: 'pom.xml',
                        type: 'pom']
                        ]
                    )
                    } else {
                        error "*** File: ${artifactPath}, could not be found"
                    }
                }
            }
        }
    }
}




