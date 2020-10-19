# JumpServer 分析

Jumpserver 是一款由python编写开源的跳板机(堡垒机)系统，实现了跳板机应有的功能。基于ssh协议来管理，客户端无需安装agent。完全开源，GPL授权

## 架构图

![jumpserver](images/20200526180743745_415773244.png)

## 组件说明

- **Jumpserver** 为管理后台, 管理员可以通过 Web 页面进行资产管理、用户管理、资产授权等操作, 用户可以通过 Web 页面进行资产登录, 文件管理等操作是核心组件（Core）, 使用 Django Class Based View 风格开发，支持 Restful API

- **Luna** 为 Web Terminal Server 前端页面, 用户使用 Web Terminal 方式登录所需要的组件 （ WebTerminalView ）
  该组件由团队自己通过Angular 实现，Jumpserver 只提供 API，不再负责后台渲染html等。
  
- **Koko(CoCo)** 为 SSH Server 和 Web Terminal Server 。用户可以使用自己的账户通过 SSH 或者 Web Terminal 访问 SSH 协议和 Telnet 协议资产。KoKo(最新版)是go版本的coco，新的Jumpserver ssh/ws server, 重构了 coco 的 SSH/SFTP 服务和 Web Terminal 服务 （ WebSFTPView ）

  SSH/SFTP/web terminal/web文件管理 （ WebSFTPView ）
  实现了 SSH Server 和 Web Terminal Server 的组件，提供 SSH 和 WebSocket 接口, 使用 Paramiko 和 Flask 开发

- **Guacamole** 为 RDP 协议和 VNC 协议资产组件, 用户可以通过 Web Terminal 来连接 RDP 协议和 VNC 协议资产 (暂时只能通过 Web Terminal 来访问)
 [Guacamole](http://guacamole.apache.org/) Apache 跳板机项目，Jumpserver 使用其组件实现 RDP 功能，Jumpserver 并没有修改其代码而是添加了额外的插件，支持 Jumpserver 调用。

- Jumpserver-Python-SDK
[Jumpserver Python SDK](https://github.com/jumpserver/jumpserver-python-sdk)，(KoKo)Coco 目前使用该 SDK 与 Jumpserver API 交互。

  为 Jumpserver ssh terminal 和 web terminal封装了一个sdk, 完成和Jumpserver 交互的一些功能
  - Service 通用RestApi 接口类
  - AppService 增加了app注册等
  - UserService 用户使用该类

- **jms-storage-sdk**
主要作为录像存储的工具类，支持本地或其他cloud存储（e.g. oss）

### 端口说明

- Jumpserver 默认端口为 8080/tcp 配置文件 jumpserver/config.yml

- KoKo(Coco) 默认 SSH 端口为 2222/tcp, 默认 Web Terminal 端口为 5000/tcp 配置文件在 KoKo(CoCo)/config.yml

- Guacamole 默认端口为 8081/tcp, 配置文件 /config/tomcat9/conf/server.xml

- Nginx 默认端口为 80/tcp

- Redis 默认端口为 6379/tcp

- Mysql 默认端口为 3306/tcp

## 技术实现

### 使用技术

- Python 3.6.1
- Django
- Angular (Luna)
- go （koko）
- Celery  http://www.celeryproject.org/
- Redis   cache 和 celery broke
- Flower - Celery monitoring tool
- Guacamole (webterminal -RDP)
- ...

### 服务启动

`./jms start`命令将会下面服务
  
![jms](images/20200528102354700_861856403.png)

- gunicorn  - unix系统的wsgi http服务器，负责jsm-core的http请求

- Daphne  - 支持HTTP, HTTP2 和 WebSocket 的asgi的服务器，主要处理WebSocket请求

- celery - 后台异步任务分发处理 -celery_ansible/celery_default
  简单、灵活且可靠的，处理大量消息的分布式系统；专注于实时处理的异步任务队列，同时也支持任务调度

- flower - 负责监控 celery worker执行情况

### Web Terminal

- 主要通过Luna，koko 和Guacamole实现

#### Luna

- 打开web terminal link 后，进入luna, luna 会通过api请求jms 的资源列表，进行树状展示
- webterminal 前端由luna 里的html5 canvas 和js 画出来
- 录像的回放是由 luna进行 replay 展示的，对json 进行分割处理
- 当需要进行RDP访问时，会向guacamole进行post请求 `/guacamole/api/session/ext/jumpserver/asset/add`

#### koko

- 老版本coco使用ssh python 库- Paramiko
- koko 启动时候会注册到jms, 需要配置中 “BOOTSTRAP_TOKEN” 与jump server保持一致, 用于身份认证
- 启动之后将会监听，如果有ssh 连接请求，就会建立websocket (依赖于Daphne），基于[go的websocket实现](https://github.com/gorilla/websocket)
- 用户在web terminal 窗口操作时，koko 会对命令解析，和jms里的过滤规则匹配
- 连接中断后，开始上传录像(其实是json文件，记录了时序log)到jumpserver(/data/media)
- 使用了websoket 框架 - https://github.com/kataras/neffos

    ![koko](images/20200527094248561_866134588.png)

#### Guacamole(rdp)

- 对Apache Guacamole 进行了改造，主要是Guacamole client/server war包，看不到源码改造
- 原生的Guacamole 本身可以单独提供 web terminal 服务，但是部署相对复杂，有单独的postgresql存储机器连接信息
- 改造后的Guacamole ()，也需要通过 BOOTSTRAP_TOKEN 注册到 jms

### 操作录像回放

- 操作的录制:   ssh 是由koko基于websocket data完成; rdp 是由Guacamole API 完成
- 操作的回放：由 luna进行 replay 展示的，对ssh 录像(.json) 进行分割处理,使用js渲染成动画;

    ```xml
    <elements-replay-json [replay]="replay" *ngIf="replay.type=='json'"></elements-replay-json>
    <elements-replay-guacamole [replay]="replay" *ngIf="replay.type=='guacamole'"></elements-replay-guacamole>
    ```
