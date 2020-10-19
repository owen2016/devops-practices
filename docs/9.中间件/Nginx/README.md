# Nginx

## 安装

`sudo apt-get install nginx`

## 常用命令

```text
- sudo nginx #打开 nginx
- nginx -s reload|reopen|stop|quit #重新加载配置|重启|停止|退出 nginx
- nginx -t #测试配置是否有语法错误

nginx [-?hvVtq] [-s signal] [-c filename] [-p prefix] [-g directives]

-?,-h : 打开帮助信息
-v : 显示版本信息并退出
-V : 显示版本和配置选项信息，然后退出
-t : 检测配置文件是否有语法错误，然后退出
-q : 在检测配置文件期间屏蔽非错误信息
-s signal : 给一个 nginx 主进程发送信号：stop（停止）, quit（退出）, reopen（重启）, reload（重新加载配置文件）
-p prefix : 设置前缀路径（默认是：/usr/local/Cellar/nginx/1.2.6/）
-c filename : 设置配置文件（默认是：/usr/local/etc/nginx/nginx.conf）
-g directives : 设置配置文件外的全局指令
```

直接安装nginx的方式，会自动在/etc/init.d/nginx新建服务脚本，所以我们可以直接用如下命令：

* 停止nginx:

> sudo systemctl stop nginx

* 启动nginx:

> sudo systemctl start nginx

* 重启nginx:

> sudo systemctl restart nginx

* 修改配置文件后，平滑加载配置命令(不会断开用户访问）：

> sudo systemctl reload nginx

* 默认，nginx是随着系统启动的时候自动运行。如果你不想开机启动，那么你可以禁止nginx开机启动：

> sudo systemctl disable nginx

* 重新配置nginx开机自动启动:

> sudo systemctl enable nginx

## Nginx目录结构

网站文件位置

* /var/www/html: 网站文件存放的地方, 默认只有我们上面看到nginx页面，可以通过改变nginx配置文件的方式来修改这个位置。

服务器配置

* /etc/nginx: nginx配置文件目录。所有的nginx配置文件都在这里。
* /etc/nginx/nginx.conf: Nginx的主配置文件. 可以修改他来改变nginx的全局配置。
* /etc/nginx/sites-available/: 这个目录存储每一个网站的"server blocks"。nginx通常不会使用这些配置，除非它们陪连接到  sites-enabled 目录 (see below)。一般所有的server block 配置都在这个目录中设置，然后软连接到别的目录 。
* /etc/nginx/sites-enabled/: 这个目录存储生效的 "server blocks" 配置. 通常,这个配置都是链接到 sites-available目录中的配置文件
* /etc/nginx/snippets: 这个目录主要可以包含在其它nginx配置文件中的配置片段。重复的配置都可以重构为配置片段。

日志文件

* /var/log/nginx/access.log: 每一个访问请求都会记录在这个文件中，除非你做了其它设置
* /var/log/nginx/error.log: 任何Nginx的错误信息都会记录到这个文件中
