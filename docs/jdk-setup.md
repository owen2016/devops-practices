## 安装jdk8

vim jdk-setup.sh

```
#!/bin/sh

# define

file_url="http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz"
file_name=jdk-8u191-linux-x64.tar.gz
java_dir=jdk1.8.0_191
java_home=/usr/lib/jvm

# download java
sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $file_url

# untar
sudo tar -zxvf $file_name

if [ ! -d "$java_home" ]; then
    sudo mkdir "$java_home"
fi

sudo mv $java_dir $java_home

echo "export JAVA_HOME=$java_home/$java_dir
export JRE_HOME=\$JAVA_HOME/jre
export CLASSPATH=.:\$CLASSPATH:\$JAVA_HOME/lib:\$JRE_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin" >> ~/.bashrc

```

run 

```
sudo chmod 777 jdk-setup.sh
./jdk-setup.sh
source ~/.bashrc
```