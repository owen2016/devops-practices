# Fluentd -转发配置

- vm-101： nginx所在服务器，es，fd，ka所在服务器 client agent
- vm-102： fd及插件所在服务器server agent，负责文件存储nginx日志，并转发101es存储

## vm-101 配置

- /etc/td-agent/td-agent.conf

- 添加tail 源

```
<source>
  type tail
  path /var/log/nginx/access.log
  format /^(?<remote>[^ ]*) - - \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*) +\S*)?" (?<status>[^ ]*) (?<body_bytes_sent>[^ ]*) "(?<http_referer>[^\"]*)" ClientVersion "(?<clientVersion>[^ ]*)" "(?<userAgent>[^\"]*)" "(?<remoteHost>[^ ]*)" "(?<http_x_forwarded_for>[^\"]*)" upstream_response_time "(?<upstream_response_time>[^ ]*)" request_time "(?<request_time>[^ ]*)"\s$/
  time_format %d/%b/%Y:%H:%M:%S %z
  types remote:ip,time:time,method:string,path:string,status:integer:body_bytes_sent:integer,http_referer:string,userAgent:string,remoteHost:string,http_x_forwarded_for:string,upstream_response_time:string,request_time:float
  tag 101nginx.access.log
  pos_file /var/log/td-agent/pos/nginx.access.log.pos
</source>
```

- 添加tag match 把采集的日志转发到 vm-102
```
<match *.access.log>
  type forward
  flush_interval 60s
  buffer_type file
  buffer_path /var/log/td-agent/buffer/*
  <server>
    host 10.22.205.102
    port 24224
  </server>
</match>

```

## vm-102 配置

- 1. 以时间文件夹路径本地存储nginx日志 
- 2. 转发获得的日志到101的es上

```
<match *.access.log>
  type copy
  <store>
    type file 
    path /var/log/swq_test/nginx-access/
    time_slice_format ./nginx-access/%Y/%m/%d/%Y%m%d%H.nginx.access
    compress gzip
    flush_interval 10m
    time_format %Y-%m-%dT%H:%M:%S%z
    buffer_path /var/log/swq_test/buffer/nginx_access_buffer
    buffer_type file
    buffer_chunk_limit 50m
  </store>
  <store>
    type elasticsearch
    host 10.22.205.101
    port 9200
    include_tag_key true
    tag_key @log_name
    logstash_format true
    flush_interval 10s
  </store>
</match>

```