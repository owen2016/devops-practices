# EFK (Elasticsearch+Fluentd+kibana)--> 收集容器日志(e.g. nginx )

EFK需要用到elasticsearch、fluentd以及kibana，nginx使用fluentd日志驱动将nginx docker日志转发到对应fluentd server端，fluentd server端将日志加工后传递到elasticsearch，存储到elasticsearch的数据就可以使用kibana展示出来

1. 部署ek环境
2. 部署fluentd环境 

- fluent_fluentd是自己构建的镜像

```
FROM fluent/fluentd
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "1.9.5"]
```

```
version: "3"
services:
  fluentd:
    build: ./fluentd
    volumes:
      - ./fluentd/conf:/fluentd/etc
    privileged: true
    ports:
      - "24224:24224"
      - "24224:24224/udp"
    environment:
      - TZ=Asia/Shanghai
    restart: always
    logging:
        driver: "json-file"
        options:
            max-size: 100m

```

**配置文件**
```
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>
<filter nginx>
  @type parser
  key_name log
  <parse>
        @type regexp
        expression (?<remote>[^ ]*) (?<user>[^ ]*) \[(?<localTime>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*) (?<requestTime>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)"(?:\s+(?<http_x_forwarded_for>[^ ]+))?)?
        time_format %d/%b/%Y:%H:%M:%S %z
  </parse>
</filter>
<match nginx>
  @type copy
  <store>
    @type elasticsearch
    host 172.21.48.48
    port 9200
    logstash_format true
    logstash_prefix nginx
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    flush_interval 1s
    include_tag_key true
    tag_key @log
  </store>
  <store>
    @type stdout
  </store>
```

注意上面的正则表达式对应的nginx日志格式为：
```
    log_format  main  '$remote_addr $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent $request_time "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
```

```xml
<source>
  @type tail
  path /var/log/containers/*.log
  pos_file /var/log/es-containers.log.pos
  time_format %Y-%m-%dT%H:%M:%S.%NZ
  localtime
  tag docker.logs
  format json
  read_from_head true
</source>
<filter docker.logs>
  @type record_transformer
  <record>
    host "#{Socket.gethostname}"
  </record>
</filter>
<match docker.logs>
  @type elasticsearch
  host 192.168.3.130
  port 9200
  logstash_format true
</match>

```