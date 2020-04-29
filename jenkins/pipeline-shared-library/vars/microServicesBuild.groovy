// 获得最近1分钟的commit信息,在commit信息中获取每个需要重新build的微服务名称.
// 微服务名称在commit信息中使用[]包裹, 空格分割如:[spring-boot-eureka] [spring-boot-hello],
// 在commit信息中结尾的微服务名称可以没有结束符']'
// 如: Build microservies [spring-boot-config] [spring-boot-gateway
// 微服务spring-boot-config和spring-boot-gateway都将被重新build

def getServiceNames(String commitMessage) {
    def serviceNames = ''
    if(commitMessage) {
        def startInput = false
        for (c in commitMessage) {
            switch(c) {
                case '[':
                    startInput = true
                break
                case ']':
                    if(startInput) {
                        startInput = false
                        serviceNames += ' '
                    }
                break
                default:
                    if(startInput) {
                       serviceNames += c
                    }
                break
            }
        }
    }
    return serviceNames
}

def call(String type = '', String active = '') {
    def latestCommit = sh(returnStdout: true, script: 'git log --pretty=format:"%s" --since="1 minutes ago" -1').trim();
    def serviceNames = ''
    if(latestCommit) {
        serviceNames = getServiceNames(latestCommit)
    }
    if(!serviceNames) {
        println 'Not service name specified in commit message, so all the sevices will be built.'
    }

    if(type == 'maven') {
        def projectList = ''
        if(serviceNames) {
            projectList = '-pl ' + serviceNames
        }
        // 这里的方式并不理想, 不会根据当前的状态选择性的执行maven的生命阶段
        if(active == 'build') {
            try {
               sh "mvn ${projectList} clean package -DskipTests"
            } catch(e) {
               println "Encountering the above error all the services will be building."
               sh "mvn clean package -DskipTests"
            }
        } else if(active == 'test') {
            try {
               sh "mvn ${projectList} clean test"
            } catch(e) {
               println "Encountering the above error all the services will be testing."
               sh "mvn clean test"
            }
        } else if(active == 'deploy') {
            try {
               sh "mvn ${projectList} clean deploy"
            } catch(e) {
               println "Encountering the above error all the services will be deploying."
               sh "mvn clean deploy"
            }
        } else {
            throw new RuntimeException("Oops, active(${active}) not found!")
        }
    }
}