# Let’s Encrypt

[TOC]

Let’s Encrypt是一个由非营利性组织互联网安全研究小组（ISRG）提供的免费、自动化和开放的证书颁发机构（CA）。
简单的说，借助Let’s Encrypt颁发的证书可以为我们的网站免费启用HTTPS(SSL/TLS)

- https://letsencrypt.org/zh-cn/docs/

## 客户端

Let’s Encrypt 使用 ACME 协议来验证您对给定域名的控制权并向您颁发证书。要获得 Let’s Encrypt 证书，您需要选择一个要使用的 ACME 客户端软件。Let’s Encrypt 不控制或审查第三方客户端，也不能保证其安全性或可靠性。

官方提供了几种证书的申请方式方法

- https://letsencrypt.org/zh-cn/docs/client-options/

### certbot

它既可以仅为您获取证书，也可以帮助您安装证书（如果您需要的话）。它易于使用，适用于许多操作系统，并且具有出色的文档。

https://certbot.eff.org/

### acme.sh

目前 Let's Encrypt 免费证书客户端最简单、最智能的 shell 脚本，可以自动发布和续订 Let's Encrypt 中的免费证书

- https://github.com/acmesh-official/acme.sh

## 安装acme.sh

### 1. 自动安装

`curl https://get.acme.sh | sh` (网络问题可能失败)

### 2. 手动安装

``` shell
git clone https://github.com/acmesh-official/acme.sh.git
cd ./acme.sh
./acme.sh --install
```

安装过程如下：

1. 默认安装到当前用户的主目录$HOME下的.acme.sh文件夹中，即`~/.acme.sh/`，之后所有生成的证书也会按照域名放在这个目录下；
2. 创建指令别名： alias acme.sh=~/.acme.sh/acme.sh， 通过`acme.sh`命令方便快速地使用 acme.sh 脚本
3. 自动创建cronjob定时任务，每天 0:00 点自动检测所有的证书，如果快过期了，则会自动更新证书

    ``` shell
    #每天 0:00 点自动检测所有的证书, 如果快过期了, 需要更新, 则会自动更新证书
    0 0 * * * /root/.acme.sh/acme.sh --cron --home /root/.acme.sh > /dev/null
    ```

### 3. 测试收否安装成功

``` shell
user@owen-ubuntu:~$ acme.sh --version
https://github.com/acmesh-official/acme.sh
v2.8.8
```

如有版本信息输出则表示环境正常；如果提示命令未找到，执行source ~/.bashrc命令重载一下环境配置文件。

整个安装过程不会污染已有的系统任何功能和文件，所有的修改都限制在安装目录~/.acme.sh/中。

## 使用acme.sh生成证书

### 1. HTTP 方式

http 方式需要在你的网站根目录下放置一个文件, 以此来验证你的域名所有权,完成验证，只需要指定域名, 并指定域名所在的网站根目录，acme.sh 会全自动的生成验证文件, 并放到网站的根目录, 然后自动完成验证，该方式较适合独立域名的站点使用，比如博客站点等

``` shell
./acme.sh  --issue  -d mydomain.com -d www.mydomain.com  --webroot  /home/wwwroot/mydomain.com/

- issue 是acme.sh脚本用来颁发证书的指令；
- d是 --domain的简称，其后面须填写已备案的域名；
- w是 --webroot的简称，其后面须填写网站的根目录。
```

**示例：**

`./acme.sh  --issue  -d devopsing.site -d www.devopsing.site  --webroot  /var/www/html/blog/`

证书签发成功会有如下输出：

![acme-http](https://gitee.com/owen2016/pic-hub/raw/master/pics/20210101222026.png)

执行成功，默认为生成如下证书：

``` shell
root@ecs-ubuntu18:/etc/nginx/sites-available# ls ~/.acme.sh/devopsing.site/ -l
total 28
-rw-r--r-- 1 root root 1587 Dec 16 12:34 ca.cer
-rw-r--r-- 1 root root 1866 Dec 16 12:34 devopsing.site.cer
-rw-r--r-- 1 root root  642 Dec 16 12:34 devopsing.site.conf
-rw-r--r-- 1 root root 1001 Dec 16 12:33 devopsing.site.csr
-rw-r--r-- 1 root root  232 Dec 16 12:33 devopsing.site.csr.conf
-rw-r--r-- 1 root root 1679 Dec 16 12:33 devopsing.site.key
-rw-r--r-- 1 root root 3453 Dec 16 12:34 fullchain.cer
```

如果用的apache/nginx服务器, acme.sh 还可以智能的从 nginx的配置中自动完成验证, 不需要指定网站根目录:

`acme.sh --issue  -d mydomain.com   --apache`

`acme.sh --issue  -d mydomain.com   --nginx`

### 2. DNS 方式

适合用于生成范解析证书

优势：不需要任何服务器, 不需要任何公网 ip, 只需要 dns 的解析记录即可完成验证
劣势：`如果不同时配置 Automatic DNS API，使用这种方式 acme.sh 将无法自动更新证书`，每次都需要手动再次重新解析验证域名所有权`

#### 1. 生成证书记录

- https://github.com/acmesh-official/acme.sh/wiki/DNS-manual-mode

注意，第一次执行时使用 --issue，-d 指定需要生成证书的域名

`./acme.sh --issue -d *.example.com  --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please`

**参数解释：**

``` shell
--dns [dns_hook]    Use dns manual mode or dns api. Defaults to manual mode when argument is omitted.

--yes-I-know-dns-manual-mode-enough-go-ahead-please  Force use of dns manual mode.
See:  https://github.com/acmesh-official/acme.sh/wiki/dns-manual-mode
```

#### 2. 在域名解析中手动添加TXT记录

如果第一次添加该域名，会提示如下信息，需要在DNS解析中添加`TXT`记录，用作判断你是否拥有域名使用权

``` shell
[Wed Dec 16 16:04:49 CST 2020] Add the following TXT record:
[Wed Dec 16 16:04:49 CST 2020] Domain: '_acme-challenge.devopsing.site'
[Wed Dec 16 16:04:49 CST 2020] TXT value: '-jEWdpI**************EVh01_a3ywrW426wmppjuDqXOs'
[Wed Dec 16 16:04:49 CST 2020] Please be aware that you prepend _acme-challenge. before your domain
[Wed Dec 16 16:04:49 CST 2020] so the resulting subdomain will be: _acme-challenge.devopsing.site
[Wed Dec 16 16:04:49 CST 2020] Please add the TXT records to the domains, and re-run with --renew.
[Wed Dec 16 16:04:49 CST 2020] Please add '--debug' or '--log' to check more details.
[Wed Dec 16 16:04:49 CST 2020] See: https://github.com/acmesh-official/acme.sh/wiki/How-to-debug-acme.sh
```

![aliyun-dns](https://gitee.com/owen2016/pic-hub/raw/master/pics/20210101215207.png)

验证解析生效

``` shell
user@owen-ubuntu:~$ nslookup -q=TXT _acme-challenge.devopsing.site
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
_acme-challenge.devopsing.site	text = "-jEWdpI****************1_a3ywrW426wmppjuDqXOs"

Authoritative answers can be found from:
```

#### 3. 重新生成证书

注意，这里第二次执行是用的是 --renew

`./acme.sh --renew -d *.example.com  --yes-I-know-dns-manual-mode-enough-go-ahead-please`

**示例：**

`./acme.sh --issue -d *.devopsing.site  --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please`

![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20210101222244.png)

``` shell
root@ecs-ubuntu18:/var/log/nginx# ls ~/.acme.sh/\*.devopsing.site/ -l
total 28
-rw-r--r-- 1 root root 1587 Dec 16 16:09  ca.cer
-rw-r--r-- 1 root root 1846 Dec 16 16:09 '*.devopsing.site.cer'
-rw-r--r-- 1 root root  613 Dec 16 16:09 '*.devopsing.site.conf'
-rw-r--r-- 1 root root  980 Dec 16 16:09 '*.devopsing.site.csr'
-rw-r--r-- 1 root root  211 Dec 16 16:09 '*.devopsing.site.csr.conf'
-rw-r--r-- 1 root root 1679 Dec 16 16:04 '*.devopsing.site.key'
-rw-r--r-- 1 root root 3433 Dec 16 16:09  fullchain.cer
```

#### 4. 使用DNS API的模式进行证书申请 (支持自动更新)

dns 方式的真正强大之处在于可以使用域名解析商提供的 api 自动添加 txt 记录完成验证，acme.sh 目前支持 cloudflare, dnspod, cloudxns, godaddy 以及 ovh 等数十种解析商的自动集成。

- https://github.com/acmesh-official/acme.sh/wiki/dnsapi

##### 阿里云DNS API

首先获取阿里云的操作API 的 AccessKey ID和AccessKey Secret

``` shell
export Ali_Key="key值"
export Ali_Secret="key Secret"
# 给出的 api id 和 api key 会被自动记录下,下次就不用再次执行上述命令

acme.sh --issue --dns dns_ali -d *.example.com --force
```

**示例：**

``` shell
export Ali_Key="LTAI4F****i8qEeKeRios2r"
export Ali_Secret="nIpymix0s****a0bJNgERE0QzjSrkF"
acme.sh --issue --dns dns_ali -d *.devopsing.site --force
```

##### DnsPod API

``` shell
export DP_Id="1234"
export DP_Key="sADDsdasdgdsf"
acme.sh --issue  --dns dns_dp   -d *.example.com
```

## 查看/删除证书

查看安装证书 `acme.sh --list`

![acme-list](https://gitee.com/owen2016/pic-hub/raw/master/pics/20210101222307.png)

删除证书 `acme.sh remove <SAN_Domains>`

``` shell
user@ecs-ubuntu18:~$ acme.sh remove devopsing.site
[Thu Dec 17 14:05:53 CST 2020] devopsing.site is removed, the key and cert files are in /home/user/.acme.sh/devopsing.site
[Thu Dec 17 14:05:53 CST 2020] You can remove them by yourself.
```

## 使用acme.sh安装证书

上面生成的证书放在了`~/.acem.sh/<domain>`目录，使用`--installcert`命令，指定目标位置，可将证书copy 到相应的位置

### Nginx 示例

``` shell
acme.sh --installcert -d <domain>.com \
--key-file /etc/nginx/ssl/<domain>.key \
--fullchain-file /etc/nginx/ssl/fullchain.cer \
--reloadcmd "service nginx force-reload"
```

如果要直接加载配置，可以使用 --reloadcmd "service nginx force-reload"，但是由于nginx 的配置可能不尽相同，所以一般选择手动 reload nginx

注意:Nginx 的配置 ssl_certificate 使用 /etc/nginx/ssl/fullchain.cer ，而非 /etc/nginx/ssl/<domain>.cer ，否则 SSL Labs 的测试会报 Chain issues Incomplete 错误

``` conf
server {
        listen 443 ssl;
        server_name demo.com;
        
        ssl on;
        ssl_certificate      /etc/nginx/ssl/fullchain.cer;
        ssl_certificate_key  /etc/nginx/ssl/<domain>.key;
```

### Apache 示例

./acme.sh --install-cert -d *.example.com \
--cert-file      /path/to/certfile/in/apache/cert.pem  \
--key-file       /path/to/keyfile/in/apache/key.pem  \
--fullchain-file /path/to/fullchain/certfile/apache/fullchain.pem \
--reloadcmd     "service apache2 force-reload"

## 更新证书

目前 Let's Encrypt 的证书有效期是90天，时间到了会自动更新，无需任何操作。但是，也可以强制续签证书：

`acme.sh --renew -d example.com --force`

注：手动添加DNS获取证书的方式无法自动更新，但是使用DNS API的方式进行获取证书可以在证书有效期后自动更新, 你无需任何操作

强制执行更新任务 `acme.sh --cron -f`

![acme-cron](https://gitee.com/owen2016/pic-hub/raw/master/pics/20210101222329.png)

## 更新acme.sh

acme 协议和 letsencrypt CA 都在频繁的更新, 因此 acme.sh 也经常更新以保持同步。

手动更新： `acme.sh --upgrade`

开启自动更新：`acme.sh --upgrade --auto-upgrade`

取消自动更新： `acme.sh --upgrade --auto-upgrade 0`

## 删除acme.sh

``` shell
user@owen-ubuntu:~$ acme.sh --uninstall
[2020年 12月 18日 星期五 15:55:11 CST] Removing cron job
[2020年 12月 18日 星期五 15:55:11 CST] LE_WORKING_DIR='/home/user/.acme.sh'
[2020年 12月 18日 星期五 15:55:11 CST] Uninstalling alias from: '/home/user/.bashrc'
[2020年 12月 18日 星期五 15:55:11 CST] The keys and certs are in "/home/user/.acme.sh", you can remove them by yourself.
```
