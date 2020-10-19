# GitLab 安装

[GitLab](https://docs.gitlab.com/ee/README.html) 是一个用于仓库管理系统的开源项目，使用Git作为代码管理工具，并在此基础上搭建起来的web服务。

参考
- https://about.gitlab.com/install/

## 编译安装

• 优点：可定制性强。数据库既可以选择MySQL,也可以选择PostgreSQL;服务器既可以选择Apache，也可以选择Nginx。
• 缺点：国外的源不稳定，被墙时，依赖软件包难以下载。配置流程繁琐、复杂，容易出现各种各样的问题。依赖关系多，不容易管理，卸载GitLab相对麻烦。

参考

- Installation from source
https://docs.gitlab.com/ee/install/installation.html 

- https://www.cnblogs.com/Alex-qiu/p/7845626.html

## 通过rpm/apt包安装

• 优点：安装过程简单，安装速度快。采用rpm包安装方式，安装的软件包便于管理。
• 缺点：数据库默认采用PostgreSQL，服务器默认采用Nginx，不容易定制。

通过GitLab官方提供的Omnibus安装包来安装，相对方便。Omnibus安装包套件整合了大部分的套件（Nginx、ruby on rails、git、redis、postgresql等），再不用额外安装这些软件，减轻了绝大部分安装量，相当于一键安装。

安装过程可以参考[GitLab Docker images](https://docs.gitlab.com/omnibus/docker/#run-the-image)

## 通过dokcer运行

### 1. 创建gitlab相关目录
```bash
mkdir -p /data/gitlab/config
mkdir -p /data/gitlab/logs
mkdir -p /data/gitlab/data

# 赋予相关权限
chmod -R 777 /data
```

### 2. 用docker启动gitlab

```bash
docker run --detach \
    --hostname gitlab.company.com \
    --publish 443:443 --publish 80:80 --publish 2289:22 \
    --name gitlab \
    --restart always \
    --volume /data/gitlab/config:/etc/gitlab \
    --volume /data/gitlab/logs:/var/log/gitlab \
    --volume /data/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:VERSION
```

### 3. 修改相关配置

> docker启动gitlab之后，会创建默认的配置文件`gitlab.rb`,修改配置文件`/data/gitlab/config/gitlab.rb`

**注意：** 配置文件路径和docker启动gitlab挂载的配置文件路径一致。

```bash
vim /data/gitlab/config/gitlab.rb
```

修改如下配置（没有则添加）：

```vim
gitlab_rails['gitlab_ssh_host'] = 'gitlab.company.com'
gitlab_rails['gitlab_shell_ssh_port'] = 2289
gitlab_rails[‘time_zone’] = ‘Asia/Shanghai’
```

> 重启gitlab

```bash
docker restart gitlab
```
