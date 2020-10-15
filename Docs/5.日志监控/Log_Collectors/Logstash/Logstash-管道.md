# Logstash-管道

Logstash Pipeline 具备 2 个必需元素：input 和 output，还有 1 个可选元素：filter。

- input插件：提取数据。 这可以来自日志文件，TCP或UDP侦听器，若干协议特定插件（如syslog或IRC）之一，甚至是排队系统（如Redis，AQMP或Kafka）。 此阶段使用围绕事件来源的元数据标记传入事件。

- filter 插件：插件转换并丰富数据

- output插件: 将已处理的事件加载到其他内容中，例如ElasticSearch或其他文档数据库，或排队系统，如Redis，AQMP或Kafka。 它还可以配置为与API通信。 也可以将像PagerDuty这样的东西连接到Logstash输出）

这里的input可以支持多个input，同时多个worker可以处理filter及output:

![logstash-3](./images/logstash-3.png)

最简单且最基本的 Logstash Pipeline 如下所示：

``` json
input { stdin { } }#该行可有可无，写来打印测试而已
input {
    #开启tcp插件的监听
    tcp {
    host => "127.0.0.1" #这个需要配置成本机IP，不然logstash无法启动
    port => 9600 #端口号
    codec => json_lines #将日志以json格式输入
  }
}

output {
   #输出打印
    stdout { codec => rubydebug }
}
```

## 处理多个 input

- 介绍了如何使用在同一个配置文件中处理 多个 input 的情况
    https://cloud.tencent.com/developer/article/1671480?from=10680

## 多个配置文件（conf）

- 绍如何来处理多个配置文件
    https://cloud.tencent.com/developer/article/1674717
    - 多个 pipeline
    - 一个 pipleline 处理多个配置文件

## Multiple Pipelines

作为生产者和消费者之间数据流的一个中心组件，需要一个 Logstash 实例负责驱动多个并行事件流的情况。默认情况下，这样的使用场景的配置让人并不太开心，使用者会遭遇所谓的条件地狱(Conditional hell)。因为每个单独的 Logstash 实例默认支持一个管道，该管道由一个输入、若干个过滤器和一个输出组成，如果要处理多个数据流，就要到处使用条件判断。

- 条件地狱(Conditional hell)--->> https://www.cnblogs.com/sparkdev/p/11073980.html

- https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html

- https://www.codeproject.com/Tips/5271551/Configure-Multiple-Pipeline-in-Logstash

``` yaml
- pipeline.id: apache
  pipeline.batch.size: 125
  queue.type: persisted
  path.config: "/path/to/config/apache.cfg"
  queue.page_capacity: 50mb

- pipeline.id: test
  pipeline.batch.size: 2
  pipeline.batch.delay: 1
  queue.type: memory
  config.string: "input { tcp { port => 3333 } } output { stdout {} }"

```