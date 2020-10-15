# Fluentd 插件

对于Fluentd来说，大部分重要的数据input/output都由插件管理。每个插件知道如何和外部的应用对接。

- [List of Plugins By Category](https://www.fluentd.org/plugins)

Fluentd有七种类型的插件：输入(Input)，分析器(Parser)，过滤器(Filter)，输出(Output)，格式化(Formatter)，存储(Storage)，缓冲(Buffer)。

1. Input
    输入插件。内置的有tail、http、tcp、udp等
    - <https://docs.fluentd.org/Input>

2. Parser
    解析器。可自定义解析规则，如解析nginx日志
    - <https://docs.fluentd.org/Parser>

3. Filter
    Filter插件，可过滤掉事件，或增加字段，删除字段
    - <https://docs.fluentd.org/Filter>​

4. Output
    输出插件。内置的有file、hdfs、s3、kafka、elasticsearch、mongoDB、stdout等
    - <https://docs.fluentd.org/output>

5. Formatter
    Formatter插件。可自定义输出格式如json、csv等
    - <https://docs.fluentd.org/Formatter>

6. Storage
    Storage插件可将各状态保存在文件或其他存储中，如Redis、MongoDB等
    - <https://docs.fluentd.org/Storage>​

7. Buffer
    Buffer缓冲插件。缓冲插件由输出插件使用。在输出之前先缓冲，然后以如Kafka Producer Client的方式批量提交。有file、memory两种类型。flush_interval参数决定了提交的间隔，默认60秒刷新一次
    - <https://docs.fluentd.org/output>

td-agent的很多功能实现是通过安装插件来完成的，举个例子，如果想把日志路由到amazon的s3服务，则我们要安装fluent-plugin-s3这个插件：
`sudo /usr/sbin/td-agent-gem install fluent-plugin-s3`

## 常用插件安装

部分插件内置在标准的td-agent，无需手动安装，对于有特殊需求，需要手动执行如下命令安装

- 安装fluent-plugin-elasticsearch
`/usr/sbin/td-agent-gem install fluent-plugin-elasticsearch`

- 安装fluentd type 插件
`/usr/sbin/td-agent-gem install fluent-plugin-typecast`

- 安装secure-forward 插件(非必须但常用)
`/usr/sbin/td-agent-gem install fluent-plugin-secure-forward`

查看插件是否安装成功： `td-agent-gem list`
