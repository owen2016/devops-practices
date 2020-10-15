# log-pilot

log-pilot是阿里开源的docker日志收集工具，Github项目地址 。你可以在每台机器上部署一个log-pilot实例，就可以收集机器上所有Docker应用日志。

- https://github.com/AliyunContainerService/log-pilot
  - registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.7-filebeat
  - registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.7-fluentd

**特性：**

- 一个单独的 log-pilot 进程收集机器上所有容器的日志。不需要为每个容器启动一个 log-pilot 进程。
- 支持文件日志和 stdout。docker log dirver 亦或 logspout 只能处理 stdout，log-pilot 不仅支持收集 stdout 日志，还可以收集文件日志。
- 声明式配置。当您的容器有日志要收集，只要通过 label 声明要收集的日志文件的路径，无需改动其他任何配置，log-pilot 就会自动收集新容器的日志。
- 支持多种日志存储方式。无论是强大的阿里云日志服务，还是比较流行的 elasticsearch 组合，甚至是 graylog，log-pilot 都能把日志投递到正确的地点。