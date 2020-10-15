# Logstash

[Logstash](https://www.elastic.co/cn/logstash)是免费且开放的服务器端数据处理管道，能够从多个来源采集数据，转换数据，然后将数据发送到您最喜欢的“存储库”中。

Logstash能够动态地**采集、转换和传输数据**，不受格式或复杂度的影响。利用Grok从非结构化数据中派生出结构，从IP地址解码出地理坐标，匿名化或排除敏感字段，并简化整体处理过程。

![logstash-2](./images/logstash-2.png)

## 运行机制

Logstash使用**管道方式**进行日志的搜集处理和输出。有点类似Linux的管道命令 xxx | ccc | ddd，xxx执行完了会执行ccc，然后执行ddd

包括了三个阶段: 输入input --> 处理filter（不是必须的） --> 输出output

![logstash-1](./images/logstash-1.png)

每个阶段都由很多的插件配合工作，比如file、elasticsearch、redis等等。

每个阶段也可以指定多种方式，比如输出既可以输出到elasticsearch中，也可以指定到stdout在控制台打印。

## 安装

- https://www.elastic.co/guide/en/logstash/current/index.html

### Docker部署

```text
    docker run -d -it --restart=always \
    --privileged=true \
    --name=logstash -p 5040:5040 -p 9600:9600  \
    -v /data/logstash/pipeline/:/usr/share/logstash/pipeline/  \
    logstash:6.8.0
```

```text
    docker run -d -it --restart=always \
    --privileged=true \
    --name=logstash -p 4560-4570:4560-4570  -p 9600:9600  \
    --link elasticsearch \
    --net efk_default \
    -v /data/logstash/pipeline/:/usr/share/logstash/pipeline/  \
    logstash:6.8.0
```
