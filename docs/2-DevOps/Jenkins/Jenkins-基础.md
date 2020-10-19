# Jenkins

[Jenkins](https://jenkins.io/doc/) 是一个独立的开源自动化服务器，可以用来自动化与构建、测试、交付或部署软件相关的所有任务。

安装过程参考[Installing Jenkins on Ubuntu](https://wiki.jenkins.io/display/JENKINS/Installing+Jenkins+on+Ubuntu)

## 安装步骤

### 1. JDK 安装

Jenkins依赖java环境， 请先确保java环境已安装好， java安装流程如下：

* 下载jdk8 tar.gz包从[jdk download page](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

* 解压tar.gz包

* 配置环境变量`JAVA_HOME`, `JRE_HOME`，`CLASSPATH`， `PATH`

* 检查是否安装成功:  `java & javac`

    ```
    sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz

    tar -zxvf ${your_download_path}/jdk-8u191-linux-x64.tar.gz

    mv ${your_download_path}/jdk1.8.0_191 /usr/local/

    ```

    ```bash
    vim /etc/profile
    # 在文件末尾加上下面内容:
    export JAVA_HOME="/usr/local/jdk1.8.0_191"
    export PATH=$PATH:$JAVA_HOME/bin
    ```

- 使环境变量生效:

    ```bash
    source /etc/profile
    ```

### 2. jenkins 安装

- 安装步骤

    ```
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install jenkins

    # 修改jenkins配置`/etc/default/jenkins`
    vim /etc/default/jenkins

    #配置jenkins运行用户以及用户组：
    JENKINS_USER=root
    JENKINS_GROUP=root

    # 重启 jenkins
    systemctl restart jenkins
    ```

