# EFK (Elasticsearch+Fluentd+kibana) ---> 收集logfile (e.g. nginx)

## 安装Elasticsearch

```shell
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

apt update
apt install elasticsearch
```

### 配置Elasticsearch

- 编辑Elasticsearch的主配置文件elasticsearch.yml

`vim /etc/elasticsearch/elasticsearch.yml`

修改network.host的值--->network.host: localhost

- 启动Elasticsearch服务

```shell
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
```

- 通过发送HTTP请求来测试Elasticsearch服务是否正在运行：
`curl -X GET "localhost:9200"`

## 安装kibana

因为上一步已经添加了Elastic包源，所以可以使用apt安装Elastic Stack的其余组件：

```shell
apt install kibana
systemctl enable kibana
systemctl start kibana
```

访问Kibana: http://localhost:5601/

## 安装Fluentd(td-agent)

Fluentd是用Ruby写的，有些用户可能不太熟悉Ruby相关的操作，所以官方也提供了另外一种类型的Fluentd，叫td-agent，他们是等价的。

```shell
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh

systemctl start td-agent.service

```

### 验证Fluentd是否工作

- 查看进程状态：

  `sudo systemctl status td-agent.service`

- 查看td-agent.log

  Fluentd配置文件(/etc/td-agent/td-agent.conf)已经默认配置了从HTTP接受log并路由到本身的log文件（/var/log/td-agent/td-agent.log），所以只需执行如下命令：

  `$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test`

  并且在log中看到对应输出即可：` tail -f /var/log/td-agent/td-agent.log `

  ![td-agent-1](./images/td-agent-1.png)

### 安装插件

```shell
td-agent-gem install fluent-plugin-elasticsearch //安装fluentd的elasticsearch插件

td-agent-gem list //查看安装的插件
```

## 配置

1. 修改td-agent配置文件

    `vim /etc/td-agent/td-agent.conf`

添加如下code：

```xml
    <source>
    @type tail
    path /var/log/nginx/access.log
    pos_file /var/log/td-agent/access.log.pos
    tag nginx.access
    <parse>
        @type nginx
    </parse>
    </source>

    <source>
    @type tail
    path /var/log/nginx/error.log
    pos_file /var/log/td-agent/error.log.pos
    tag nginx.error
    <parse>
        @type regexp
        expression \[(?<log_level>\w+)\] (?<pid>\d+).(?<tid>\d+): (?<message>.*)$
    </parse>
    </source>

    <match nginx.**>
    @type elasticsearch
    host localhost
    port 9200
    logstash_format true
    logstash_prefix ${tag}
    </match>

```

2. 重启td-agent

   `sudo systemctl restart td-agent.service`

3. 访问nginx网站用于获取access的log

4. 访问kibana的网站 - http://localhost:5601

  进到Management tab，创建index，能看到类似nginx.access-2019.4.11 or nginx.error-2019.4.11 的index即表示fluentd的log已经push到了kibana

  ![efk-1](./images/efk-1.png)