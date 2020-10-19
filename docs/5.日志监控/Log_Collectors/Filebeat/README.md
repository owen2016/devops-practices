# Filebeat

[TOC]

[Filebeat](https://www.elastic.co/cn/beats/filebeat)是本地文件的日志数据采集器，可监控日志目录或特定日志文件（tail file），并将它们转发给Elasticsearch或Logstatsh进行索引、kafka等。带有内部模块（auditd，Apache，Nginx，System和MySQL），可通过一个指定命令来简化通用日志格式的收集，解析和可视化，目前来说Filebeat是 ELK 日志系统在Agent上的第一选择

Filebeat隶属于[Beats](https://www.elastic.co/cn/beats/), 是一个轻量级日志采集器。早期的ELK架构中使用Logstash收集、解析日志，但是Logstash对内存、cpu、io等资源消耗比较高。相比Logstash，Beats所占系统的CPU和内存几乎可以忽略不计。

Beats是用于单用途数据托运人的平台。它们以轻量级代理的形式安装，并将来自成百上千台机器的数据发送到Logstash或Elasticsearch。

目前Beats包含多种工具：

- Packetbeat：网络数据（收集网络流量数据）
- Metricbeat：指标（收集系统、进程和文件系统级别的CPU和内存使用情况等数据）
- Filebeat：日志文件（收集文件数据）
- Winlogbeat：windows事件日志（收集Windows事件日志数据）
- Auditbeat：审计数据（收集审计日志）
- Heartbeat：运行时间监控（收集系统运行时的数据）
- ...

## 安装

- <https://www.elastic.co/guide/en/beats/filebeat/current/setting-up-and-running.html>

## 配置

- <https://www.elastic.co/guide/en/beats/filebeat/current/howto-guides.html>

## 命令

Filebeat提供了一个用于运行Beat和执行常见任务的命令行界面，如测试配置文件和加载仪表板。 命令行还支持用于控制全局行为的全局标志

- <https://www.elastic.co/guide/en/beats/filebeat/current/command-line-options.html>

```text
命令：
    export    将配置或索引模板导出到stdout。
    help      显示任何命令的帮助。
    keystore  管理秘密密钥库。
    modules   管理配置的模块。
    run       运行Filebeat。如果在未指定命令的情况下启动Filebeat，则默认使用此命令。
    setup     设置初始环境，包括索引模板，Kibana仪表板（如果可用）和机器学习作业（如果可用）。
    test      测试配置。
    version   显示有关当前版本的信息。
```

Filebeat 启动命令： `nohup ./filebeat -e -c filebeat.yml >/dev/null 2>&1 &`

Filebeat 可以启动多个，通过不同的 *-filebeat.yml 配置文件启动

## 目录结构

不同的安装方式，目录结构可能有所不同

- <https://www.elastic.co/guide/en/beats/filebeat/current/directory-layout.html>

## 特点

EFK把ELK的Logstash替换成了FileBeat，因为Filebeat相对于Logstash来说有2个好处：

1、侵入低，无需修改程序目前任何代码和配置
2、相对于Logstash来说性能高，Logstash对于IO占用很大

当然FileBeat也并不是完全好过Logstash，毕竟Logstash对于日志的格式化这些相对FileBeat好很多，FileBeat只是将日志从日志文件中读取出来，当然如果你日志本身是有一定格式的，FileBeat也可以格式化，但是相对于Logstash来说，还是差一点
