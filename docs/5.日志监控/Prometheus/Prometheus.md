# Prometheus 

>[Prometheus](https://prometheus.io/docs/introduction/overview/) 是一套开源的监控&报警&时间序列数据库的组合,起始是由SoundCloud公司开发的。成立于2012年，之后许多公司和组织接受和采用prometheus,他们便将它独立成开源项目，并且有公司来运作.该项目有非常活跃的社区和开发人员，目前是独立的开源项目，任何公司都可以使用它，2016年，Prometheus加入了云计算基金会，成为kubernetes之后的第二个托管项目.google SRE的书内也曾提到跟他们BorgMon监控系统相似的实现是Prometheus。现在最常见的Kubernetes容器管理系统中，通常会搭配Prometheus进行监控。

## 特点

- 自定义多维数据模型(时序列数据由metric名和一组key/value标签组成)

- 非常高效的存储 平均一个采样数据占 ~3.5 bytes左右，320万的时间序列，每30秒采样，保持60天，消耗磁盘大概228G。

- 在多维度上灵活且强大的查询语言(PromQl)

- 不依赖分布式存储，支持单主节点工作

- 通过基于HTTP的pull方式采集时序数据

- 可以通过push gateway进行时序列数据推送(pushing)

- 可以通过服务发现或者静态配置去获取要采集的目标服务器

- 多种可视化图表及仪表盘支持

## 架构以及生态系统组件

![Prometheus_architecture](https://prometheus.io/assets/architecture.png)

## 组件

Prometheus生态系统由多个组件组成，它们中的一些是可选的。多数Prometheus组件是Go语言写的，这使得这些组件很容易编译和部署。

- Prometheus Server
  主要负责数据采集和存储，提供[PromQL查询语言](https://songjiayang.gitbooks.io/prometheus/content/promql/summary.html)的支持。

- 客户端SDK
  官方提供的客户端类库有go、java、scala、python、ruby，其他还有很多第三方开发的类库，支持nodejs、php、erlang等。

- Push Gateway
  支持临时性Job主动推送指标的中间网关。主要是实现接收由Client push过来的指标数据，在指定的时间间隔，由主程序来抓取

- Exporter
  Prometheus的一类数据采集组件的总称。它负责从目标处搜集数据，并将其转化为Prometheus支持的格式。与传统的数据采集组件不同的是，它并不向中央服务器发送数据，而是等待中央服务器主动前来抓取。

  Prometheus提供多种类型的Exporter用于采集各种不同服务的运行状态。目前支持的有数据库、硬件、消息中间件、存储系统、HTTP服务器、JMX等。

   不同的 exporter 用于不同场景下的数据收集，如收集主机信息的 node_exporter，收集 MongoDB 信息的 MongoDB exporter 

- alertmanager
  警告管理器，用来进行报警。

- 其他辅助性工具

## 基本概念

### 数据模型

Prometheus 存储的是“时序数据”, 即按照相同时序(相同的名字和标签)，以时间维度存储连续的数据的集合。

**时序(time series)** 是由名字(Metric)，以及一组 key/value 标签定义的，具有相同的名字以及标签属于相同时序。

`<metric name>{<label name>=<label value>, ...}`

e.g.

- http_requests_total, 可以表示 http 请求的总数

- http_requests_total{method="POST"} 可以表示所有 http 中的 POST 请求

### 时序类型

- Counter

  表示收集的数据是按照某个趋势（增加／减少）一直变化的，我们往往用它记录服务请求总量、错误总数等。
- Gauge

  表示搜集的数据是一个瞬时的值，与时间没有关系，可以任意变高变低，往往可以用来记录内存使用率、磁盘使用率等
- Histogram

  主要用于表示一段时间范围内对数据进行采样（通常是请求持续时间或响应大小），并能够对其指定区间以及总数进行统计，通常它采集的数据展示为直方图。

- Summary

  和 Histogram 类似，主要用于表示一段时间内数据采样结果（通常是请求持续时间或响应大小），它直接存储了 quantile 数据，而不是根据统计区间计算出来的

## 作业和实例

Prometheus 中，将任意一个独立的数据源（target）称之为实例（instance）。包含“相同类型的实例的集合“称之为作业（job）。 如下是一个含有四个重复实例的作业：

- job: api-server
  - instance 1: 1.2.3.4:5670
  - instance 2: 1.2.3.4:5671
  - instance 3: 5.6.7.8:5670
  - instance 4: 5.6.7.8:5671

Prometheus 在采集数据的同时，会自动在时序的基础上添加标签，作为数据源（target）的标识，以便区分：

- job: The configured job name that the target belongs to.
- instance: The <host>:<port> part of the target's URL that was scraped.

如果其中任一标签已经在此前采集的数据中存在，那么将会根据 honor_labels 设置选项来决定新标签。详见官网解释： [scrape configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)

对每一个实例而言，Prometheus 按照以下时序来存储所采集的数据样本：
```
up{job="<job-name>", instance="<instance-id>"}: 1 表示该实例正常工作
up{job="<job-name>", instance="<instance-id>"}: 0 表示该实例故障

scrape_duration_seconds{job="<job-name>", instance="<instance-id>"} 表示拉取数据的时间间隔

scrape_samples_post_metric_relabeling{job="<job-name>", instance="<instance-id>"} 表示采用重定义标签（relabeling）操作后仍然剩余的样本数

scrape_samples_scraped{job="<job-name>", instance="<instance-id>"}  表示从该数据源获取的样本数

```
其中 up 时序可以有效应用于监控该实例是否正常工作。

## Prometheus 配置

- [配置文件-prometheus.yml](http://git.augmentum.com.cn/AugCI/knowledgebase/blob/master/%E7%9B%91%E6%8E%A7/Prometheus/config/prometheus.yml)

### 全局配置

```
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # By default, scrape targets every 15 seconds.
  scrape_timeout: 10s # is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'
```

### 告警配置

```
# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 192.168.4.240:9093
```

### 规则配置

rule_files 主要用于配置 rules 文件，它支持多个文件以及文件目录

```
rule_files:
  - "rules/node.rules"
  - "rules2/*.rules"

```

### 数据拉取配置

scrape_configs 主要用于配置拉取数据节点，每一个拉取配置主要包含以下参数：

- job_name：任务名称
- honor_labels： 用于解决拉取数据标签有冲突，当设置为 true, 以拉取数据为准，否则以服务配置为准
- params：数据拉取访问时带的请求参数
- scrape_interval： 拉取时间间隔
- scrape_timeout: 拉取超时时间
- metrics_path： 拉取节点的 metric 路径
- scheme： 拉取数据访问协议
- sample_limit： 存储的数据标签个数限制，如果超过限制，该数据将被忽略，不入存储；默认值为0，表示没有限制
- relabel_configs： 拉取数据重置标签配置
- metric_relabel_configs：metric 重置标签配置

```
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
    - targets: ['192.168.4.240:9090']
      labels:
        instance: prometheus
        service: prometheus-service
  
  - job_name: 'devops_monitor'
    file_sd_configs:
      - files: 
        - ./targets/devops.json
        refresh_interval: 10s
```

### 远程可读/可写存储

remote_read 主要用于可读远程存储配置，主要包含以下参数：

- url: 访问地址
- remote_timeout: 请求超时时间

remote_write 主要用于可写远程存储配置，主要包含以下参数：

- url: 访问地址
- remote_timeout: 请求超时时间
- write_relabel_configs: 标签重置配置, 拉取到的数据，经过重置处理后，发送给远程存储

## 数据采集

一个 Exporter 本质上就是将收集的数据，转化为对应的文本格式，并提供 http 请求

```
# HELP go_memstats_heap_released_bytes Number of heap bytes released to OS.
# TYPE go_memstats_heap_released_bytes gauge
go_memstats_heap_released_bytes 5.9408384e+07

# HELP node_cpu_scaling_frequency_hertz Current scaled cpu thread frequency in hertz.
# TYPE node_cpu_scaling_frequency_hertz gauge
node_cpu_scaling_frequency_hertz{cpu="0"} 1.200286e+09
node_cpu_scaling_frequency_hertz{cpu="1"} 2.281167e+09
node_cpu_scaling_frequency_hertz{cpu="2"} 2.163574e+09
node_cpu_scaling_frequency_hertz{cpu="3"} 1.349637e+09

# Finally a summary, which has a complex representation, too:
# HELP rpc_duration_seconds A summary of the RPC duration in seconds.
# TYPE rpc_duration_seconds summary
rpc_duration_seconds{quantile="0.01"} 3102
rpc_duration_seconds{quantile="0.05"} 3272

# A histogram, which has a pretty complex representation in the text format:
# HELP http_request_duration_seconds A histogram of the request duration.
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.05"} 24054
http_request_duration_seconds_bucket{le="1"} 133988
http_request_duration_seconds_bucket{le="+Inf"} 144320
```

上面就是采集的结果示例

- 以 # HELP 开头表示 metric 帮助说明。
- 以 # TYPE 开头表示定义 metric 类型，包含 counter, gauge, histogram, summary, 和 untyped 类型。
- 其他表示一般注释，供阅读使用，将被 Prometheus 忽略
- 内容如果不以 # 开头，表示采样数据

需要特别注意的是，假设采样数据 metric 叫做 x, 如果 x 是 histogram 或 summary 类型必需满足以下条件：

- 采样数据的总和应表示为 x_sum。
- 采样数据的总量应表示为 x_count。
- summary 类型的采样数据的 quantile 应表示为 x{quantile="y"}。
- histogram 类型的采样分区统计数据将表示为 x_bucket{le="y"}。
- histogram 类型的采样必须包含 x_bucket{le="+Inf"}, 它的值等于 x_count 的值。
- summary 和 historam 中 quantile 和 le 必需按从小到大顺序排列。

## 资料

- https://legacy.gitbook.com/book/songjiayang/prometheus
- https://yunlzheng.gitbook.io/prometheus-book