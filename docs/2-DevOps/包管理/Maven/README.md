# Maven

## 安装maven

vim maven-setup.sh

```

#!/bin/sh

# define

file_url="http://apache.fayea.com/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
file_name=apache-maven-3.3.9-bin.tar.gz
maven_dir=apache-maven-3.3.9
maven_home=/usr/lib/maven
# download java
sudo wget  $file_url

# untar
sudo tar -zxvf $file_name

if [ ! -d "$maven_home" ]; then
    sudo mkdir "$maven_home"
fi

sudo mv $maven_dir $maven_home

echo "export M2_HOME=$maven_home/apache-maven-3.3.9
export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bashrc
```

```
sudo chmod 777 maven-setup.sh
./maven-setup.sh
source ~/.bashrc
```

## maven源
maven仓库用过的人都知道，国内有多么的悲催。还好有比较好用的镜像可以使用，尽快记录下来。速度提升100倍。

http://maven.aliyun.com/nexus/#view-repositories;public~browsestorage

在maven的settings.xml 文件里配置mirrors的子节点，添加如下mirror

vim $M2_HOME/conf/settings.xml 
```
    <mirror>
        <id>nexus-aliyun</id>
        <mirrorOf>*</mirrorOf>
        <name>Nexus aliyun</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public</url>
    </mirror> 
```
