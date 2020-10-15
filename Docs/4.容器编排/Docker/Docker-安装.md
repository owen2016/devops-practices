# Docker 安装

[Docker](https://docs.docker.com/get-started/) 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。

## 安装 docker

### 0. Uninstall old versions

Older versions of Docker were called docker or docker-engine. If these are installed, uninstall them:

```
sudo apt-get remove docker docker-engine docker.io
```

### 1. Set up the repository

```
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL hhttp://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

### 2. INSTALL DOCKER CE

```
sudo apt-get update
sudo apt-get install docker-ce
sudo apt-get -y install docker-ce=[VERSION]  # 安装指定版本

```

### 3. Manage Docker as a non-root user
- Create the docker group.

```
$ sudo groupadd docker

```

- Add your user to the docker group.
```
$ sudo usermod -aG docker $USER
```

### 5. 如何配置镜像加速器
https://cr.console.aliyun.com/

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://qku911ov.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 安装 docker-compose

[Docker Compose](https://docs.docker.com/compose/overview/)是一个用来定义和运行复杂应用的Docker工具。

- 执行如下命令安装docker-compose

``` bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```
