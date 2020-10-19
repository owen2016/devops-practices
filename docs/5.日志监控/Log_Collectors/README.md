# 日志采集

## 工具对比

常见的日志采集工具有 Logstash、Filebeat、Fluentd、rsyslog,etc

### Logstash VS Fluentd

Fluentd的性能会比logstash提升许多，重点在于通过这个工具，会把日志处理所消耗的资源很大程度上的降低，logstash通过JVM来运行，而fluentd完全不需要，也不会出现logstashCPU和内存占用过高的情况，

- logstash支持所有主流日志类型，插件支持最丰富，可以灵活DIY，但性能较差，JVM容易导致内存使用量高。
- fluentd支持所有主流日志类型，插件支持较多，性能表现较好。

### Logstash VS Filebeat

Logstash,功能虽然强大，但是它依赖java、在数据量大的时候，Logstash进程会消耗过多的系统资源，这将严重影响业务系统的性能，而filebeat就是一个完美的替代者，它基于Go语言没有任何依赖，配置文件简单，格式明了，同时，filebeat比logstash更加轻量级，所以占用系统资源极少，非常适合安装在生产机器上

## 容器日志收集最佳实践

- 参考： https://www.cnblogs.com/zhyg/p/10006745.html