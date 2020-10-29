# ELK 日志收集

## 使用说明

1. `chmod 777 -R /data/elasticsearch` #给777权限，不然启动elasticsearch 可能会有权限问题

2. 目录说明：

- /logstash/config 下面主要是logstash 运行时配置示例，根据实际情况进行修改

- /logstash/pipeline 下面主要放了logstash 管道配置示例，根据实际情况进行修改
  
**切记：** 准备好配置文件后，再进行docker-compose up -d

1. springboot 日志配置

参考： springboot/logback-spring.xml