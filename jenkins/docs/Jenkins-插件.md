# Jenkins 插件

- Role Strategy Plugin    　　　　　　　https://wiki.jenkins.io/display/JENKINS/Role+Strategy+Plugin
- Git Parameter Plugin    　　　　　　　http://wiki.jenkins-ci.org/display/JENKINS/Git+Parameter+Plugin
- GitHub Branch Source Plugin 　　　https://wiki.jenkins.io/display/JENKINS/GitHub+Branch+Source+Plugin
- Parameter Pool Plugin   　　　　　　　https://wiki.jenkins.io/display/JENKINS/Parameter+Pool+Plugin
- Build With Parameters Plugin   https://wiki.jenkins.io/display/JENKINS/Build+With+Parameters+Plugin
- Pipeline Plugin 　　　　　　　　　　　　　　　https://wiki.jenkins.io/display/JENKINS/Pipeline+Plugin
- SSH Slaves plugin   　　　　　　　　　　　https://wiki.jenkins.io/display/JENKINS/SSH+Slaves+plugin
- Gradle Plugin   　　　　　　　　　　　　　　　https://wiki.jenkins.io/display/JENKINS/Gradle+Plugin
- Parameterized Trigger Plugin   https://wiki.jenkins.io/display/JENKINS/Parameterized+Trigger+Plugin

## 角色配置插件

Role Strategy Plugin

## SSH相关插件

SSH Slaves plugin

## 邮件反馈

- https://plugins.jenkins.io/email-ext/
- <https://github.com/jenkinsci/email-ext-plugin>

``` groovy
stage('Email') {
    steps {
        script {
            def mailRecipients = 'XXX@xxxxx.xxx-domain'
            def jobName = currentBuild.fullDisplayName
            emailext body: '''${SCRIPT, template="groovy-html.template"}''',
            mimeType: 'text/html',
            subject: "[Jenkins] ${jobName}",
            to: "${mailRecipients}",
            replyTo: "${mailRecipients}",
            recipientProviders: [[$class: 'CulpritsRecipientProvider']]
        }
    }
}
```