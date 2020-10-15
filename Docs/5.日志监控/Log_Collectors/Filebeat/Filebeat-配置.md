# Filebeat 配置

[TOC]

- <https://www.elastic.co/guide/en/beats/filebeat/current/configuring-howto-filebeat.html>

## 配置文件

- 配置示例文件：[/etc/filebeat/filebeat.reference.yml](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-reference-yml.html)（包含所有未过时的配置项）

- 配置文件：/etc/filebeat/filebeat.yml

FileBeat的配置文件定义了在读取文件的位置，输出流的位置以及相应的性能参数，本实例是以Kafka消息中间件作为缓冲，所有的日志收集器都向Kafka输送日志流，相应的配置项如下，并附配置说明：

```yml
$ vim fileat.yml

filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /wls/applogs/rtlog/app.log
  fields:
    log_topic: appName
  multiline:
        # pattern for error log, if start with space or cause by 
        pattern: '^[[:space:]]+(at|\.{3})\b|^Caused by:'
        negate:  false
        match:   after

output.kafka:
   enabled: true
   hosts: ["kafka-1:9092","kafka-2:9092"]
   topic: applog
   version: "0.10.2.0"
   compression: gzip

processors:
- drop_fields:
   fields: ["beat", "input", "source", "offset"]

logging.level: error
name: app-server-ip
```

- paths:定义了日志文件路径，可以采用模糊匹配模式，如*.log
- fields：topic对应的消息字段或自定义增加的字段。
- output.kafka：filebeat支持多种输出，支持向kafka，logstash，elasticsearch输出数据，此处设置数据输出到kafka。
- enabled：这个启动这个模块。
- topic：指定要发送数据给kafka集群的哪个topic，若指定的topic不存在，则会自动创建此topic。
- version：指定kafka的版本。
- drop_fields：舍弃字段，filebeat会json日志信息，适当舍弃无用字段节省空间资源。
- name：收集日志中对应主机的名字，建议name这里设置为IP，便于区分多台主机的日志信息。

以上参数信息，需要用户个性化修改的主要是：paths，hosts，topic，version和name。

## Modules

- <https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-modules.html>

Filebeat提供了一组预先构建的模块，你可以使用这些模块快速实现并部署一个日志监控解决方案，包括样例指示板和数据可视化

## Input 配置

可以在filebeat.yml中的filebeat.inputs区域下指定一个inputs列表。列表是一个YMAL数组，并且你可以指定多个inputs，相同input类型也可以指定多个

```yml
filebeat.inputs:
- type: log
  paths:
    - /var/log/system.log
    - /var/log/wifi.log
- type: log
  paths:
    - "/var/log/apache2/*"
  fields:
    apache: true
  fields_under_root: true

```

### 多行日志处理

Filebeat获取的文件可能包含跨多行文本的消息，可以在filebeat.yml的filebeat.inputs区域指定怎样处理跨多行的消息

如下所示，Java堆栈跟踪由多行组成，在初始行之后的每一行都以空格开头

```text
Exception in thread "main" java.lang.NullPointerException
        at com.example.myproject.Book.getTitle(Book.java:16)
        at com.example.myproject.Author.getBookTitles(Author.java:25)
        at com.example.myproject.Bootstrap.main(Bootstrap.java:14)
```

为了把这些行合并成单个事件，如下配置将任意以空格开始的行合并到前一行

```yml
multiline.pattern: '^[[:space:]]'
multiline.negate: false
multiline.match: after
```

## Output 配置

### 配置Elasticsearch output  

- <https://www.elastic.co/guide/en/beats/filebeat/current/elasticsearch-output.html>

当指定Elasticsearch作为output时，Filebeat通过Elasticsearch提供的HTTP API向其发送数据

``` yaml
output.elasticsearch:
      hosts: ["myEShost:9200"]
      index: "filebeat-%{[beat.version]}-%{+yyyy.MM.dd}"
      username: "filebeat_internal"
      password: "{pwd}"
      #索引选择器规则数组，支持条件、基于格式字符串的字段访问和名称映射。如果索引缺失或没有匹配规则，将使用index字段
      indices:
        - index: "critical-%{[beat.version]}-%{+yyyy.MM.dd}"
          when.contains:
           message: "CRITICAL"
        - index: "error-%{[beat.version]}-%{+yyyy.MM.dd}"
          when.contains:
           message: "ERR"
```

### 配置 Logstash output

``` yml
output.logstash:
  hosts: ["127.0.0.1:5044"]
```

上面是配置Filebeat输出到Logstash，那么Logstash本身也有配置，例如：

```text
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
```

### 配置 Kafka output

```yml
output.kafka:
  # initial brokers for reading cluster metadata
  hosts: ["kafka1:9092", "kafka2:9092", "kafka3:9092"]

  # message topic selection + partitioning
  topic: '%{[fields.log_topic]}'
  partition.round_robin:
    reachable_only: false

  required_acks: 1
  compression: gzip
  max_message_bytes: 1000000
```

## Elasticsearch索引模板

- <https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-template.html>
- <https://www.elastic.co/guide/en/beats/filebeat/current/configuration-template.html>

在Elasticsearch中，索引模板用于定义设置和映射，以确定如何分析字段。相当于定义索引文档的数据结构，因为要把采集的数据转成标准格式输出）

Filebeat包已经安装了推荐的索引模板。如果你接受filebeat.yml中的默认配置，那么Filebeat在成功连接到Elasticsearch以后会自动加载模板。如果模板已经存在，不会覆盖，除非你配置了必须这样做。

通过在Filebeat配置文件中配置模板加载选项，你可以禁用自动模板加载，或者自动加载你自己的目标。

默认情况下，如果Elasticsearch输出是启用的，那么Filebeat会自动加载推荐的模板文件 —fields.yml。

``` yaml
# 加载不同的模板
setup.template.name: "your_template_name"
setup.template.fields: "path/to/fields.yml"

# 覆盖一个已存在的模板
setup.template.overwrite: true

# 禁用自动加载模板,如果将此项设置为false，则必须手动加载模板
setup.template.enabled: false

#修改索引名称
# 默认情况下，Filebeat写事件到名为filebeat-6.3.2-yyyy.MM.dd的索引，其中yyyy.MM.dd是事件被索引的日期。为了用一个不同的名字，你可以在Elasticsearch输出中设置index选项。例如：

output.elasticsearch.index: "customname-%{[beat.version]}-%{+yyyy.MM.dd}"
setup.template.name: "customname"
setup.template.pattern: "customname-*"
setup.dashboards.index: "customname-*"

```

手动加载模板

`./filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'`

## Kibana Dashboards

Filebeat附带了Kibana仪表盘、可视化示例。在你用dashboards之前，你需要创建索引模式，filebeat-*，并且加载dashboards到Kibana中。为此，你可以运行setup命令或者在filebeat.yml配置文件中配置dashboard加载

``` yaml
# 配置Kibana端点
setup.kibana:
      host: "mykibanahost:5601"
      username: "my_kibana_user"
      password: "{pwd}"
```
