# Jenkins 凭证管理

[TOC]

许多三方网站和应用可以与Jenkins交互，如Artifact仓库，基于云的存储系统和服务等. 在Jenkins中添加/配置credentials，Pipeline项目就可以使用 credentials 与三方应用交互

![](https://gitee.com/owen2016/pic-hub/raw/master/material/jenkins.jpg)

## Credential 类型

参考： <https://jenkins.io/zh/doc/book/using/using-credentials/>

**Jenkins可以存储以下类型的credentials:**

- Secret text - API token之类的token (如GitHub个人访问token)

- Username and password - 可以为独立的字段，也可以为冒号分隔的字符串：username:password(更多信息请参照 处理 credentials)

- Secret file - 保存在文件中的加密内容

- SSH Username with private key - SSH 公钥/私钥对

- Certificate - a PKCS#12 证书文件 和可选密码

- Docker Host Certificate Authentication credentials.

## Credential 安全

为了最大限度地提高安全性，在Jenins中配置的 credentials 以加密形式存储在Jenkins 主节点上（用Jenkins ID加密），并且 `只能通过 credentials ID` 在Pipeline项目中获取

这最大限度地减少了向Jenkins用户公开credentials真实内容的可能性，并且阻止了将credentials复制到另一台Jenkins实例

## Credential 创建

- 选择适合的凭证类型
  
    ![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201027222335.png)

- 创建 “Username and password” 凭证
    ![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201027223010.png)

- 创建 “SSH Username with private key” 凭证

    ![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201027222917.png)

### Credential ID 定义

- 在 ID 字段中，必须指定一个有意义的`Credential ID`- 例如 jenkins-user-for-xyz-artifact-repository。注意: 该字段是可选的。 如果您没有指定值, Jenkins 则Jenkins会分配一个全局唯一ID（GUID）值。

- **请记住：** 一旦设置了credential ID，就不能再进行更改。

## Credential 使用

参考： <https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials>

存储在Jenkins中的credentials可以被使用：

1. 适用于Jenkins的任何地方 (即全局 credentials),

2. 通过特定的Pipeline项目/项目 (在 处理 credentials 和 使用Jenkinsfile部分了解更多信息),

3. 由特定的Jenkins用户 (如 Pipeline 项目中[创建 Blue Ocean](https://jenkins.io/zh/doc/book/blueocean/creating-pipelines/)的情况).
    - Blue Ocean 自动生成一个 SSH 公共/私有密钥对, 确保 SSH 公共/私有秘钥对在继续之前已经被注册到你的Git服务器

实际使用中，下面几个场景会用到creential

- gitlab 访问、API调用
- jenkins slave 创建

### Credential 相关插件

**注意：** 上述 Credential 类型都依赖于 jenkins插件，同样jenkins pipeline 也需要这些插件的安装以支持代码片段

- Credentials Binding： <https://plugins.jenkins.io/credentials-binding/>

    -  **For secret text, usernames and passwords, and secret files**

    ```bash
    environment {
    MAGE_REPO_CREDENTIALS = credentials('COMPOSER_REPO_MAGENTO')
    COMPOSER_AUTH = """{
      "http-basic": {
          "repo.magento.com": {
              "username": "${env.MAGE_REPO_CREDENTIALS_USR}",
              "password": "${env.MAGE_REPO_CREDENTIALS_PSW}"
          }
      } }"""
   }
   ```

    - **For other credential types**

    ``` bash
    withCredentials([usernamePassword(credentialsId: 'amazon', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
    // available as an env variable, but will be masked if you try to print it out any which way
    // note: single quotes prevent Groovy interpolation; expansion is by Bourne Shell, which is what you want
    sh 'echo $PASSWORD'
    // also available as a Groovy variable
    echo USERNAME
    // or inside double quotes for string interpolation
    echo "username is $USERNAME"
    }
    ```

- Jenkins Plain Credentials Plugin: <https://plugins.jenkins.io/plain-credentials/>

    ![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201027224420.png)

- SSH Credentials: <https://plugins.jenkins.io/ssh-credentials/>

## 最佳实践

- 为了便于管理和使用， 强烈建议使用统一的约定来指定credential ID

- 建议使用类似下面的format做为credential ID， 便于jenkinsfile开发时直接使用，同时在”描述“里写清楚credential的作用

    `gitlab-api-token、gitlab-private-key、gitlab-userpwd-pair、harbor-xxx-xxx`

    ![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201027221956.png)

**实践：**

- 如下所示，将凭证使用统一的ID命名之后，便于复用，凭证定义一次，可多次，多个地方统一使用，无论是后期维护，复用都非常方便！

    ``` 
        environment {
            // HARBOR="harbor.devopsing.site"
            HARBOR_ACCESS_KEY = credentials('harbor-userpwd-pair')
            SERVER_ACCESS_KEY = credentials('deploy-userpwd-pair')
                }
        .....
        docker login --username=${HARBOR_ACCESS_KEY_USR} --password=${HARBOR_ACCESS_KEY_PSW} ${HARBOR}
        sshpass -p "${SERVER_ACCESS_KEY_PSW}" ssh -o StrictHostKeyChecking=no ${SERVER_ACCESS_KEY_USR}@${DEPLOY_SERVER} "$runCmd"
    ```
