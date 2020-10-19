# Elasticsearch-配置

## 参考

<https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html>
  
- elasticsearch.yml for configuring Elasticsearch
- jvm.options for configuring Elasticsearch JVM settings
- log4j2.properties for configuring Elasticsearch logging

## elasticsearch.yml

```yml
# 允许远程机器访问
network.host: 0.0.0.0

# 设置对外服务的http端口，默认为9200
http.port: 9200

# 设置节点之间交互的tcp端口，默认是9300
transport.tcp.port: 9300

# 搭建集群的话在局域网另一台服务器上启动ES，只要配置文件中cluster.name相同，node.name不同，就会被自动检测到

# cluster.name 用于唯一标识一个集群，不同的集群，其 cluster.name 不同，集群名字相同的所有节点自动组成一个集群。如果不配置改属性，默认值是：elasticsearch
cluster.name: es_cluster   # 集群名称

# 默认随机指定一个name列表中名字。集群中node名字不能重复
node.name: es_node_0     # 节点名称

# 访问elasticsearch-head看到没有正常连接到elasticsearch（集群健康值: 未连接），增加以下配置重启即可：
http.cors.enabled: true     #是否允许跨域REST请求
http.cors.allow-origin: "*" #允许 REST 请求来自何处

# 使用了x-pack之后，默认plugin-head是连接不上ES的，因为需要用户认证。添加下面这行即可
http.cors.allow-headers: Authorization,X-Requested-With,Content-Length,Content-Type
#plugin-head访问的时候带上用户名和密码：http://Elasticsearch:9100/?auth_user=elastic&auth_password=elastic


node.master: true 配置该结点有资格被选举为主结点（候选主结点），用于处理请求和管理集群。如果结点没有资格成为主结点，那么该结点永远不可能成为主结点；如果结点有资格成为主结点，只有在被其他候选主结点认可和被选举为主结点之后，才真正成为主结点。

node.data: true 配置该结点是数据结点，用于保存数据，执行数据相关的操作（CRUD，Aggregation）；

# discovery.zen.minimum_master_nodes: //自动发现master节点的最小数，如果这个集群中配置进来的master节点少于这个数目，es的日志会一直报master节点数目不足。（默认为1）为了避免脑裂，个数请遵从该公式 => (totalnumber of master-eligible nodes / 2 + 1)。
#脑裂是指在主备切换时，由于切换不彻底或其他原因，导致客户端和Slave误以为出现两个active master，最终使得整个集群处于混乱状态
discovery.zen.minimum_master_nodes: 2

# discovery.zen.ping.unicast.hosts： 集群各节点IP地址，也可以使用es-node等名称，需要各节点能够解析
discovery.zen.ping.unicast.hosts: ["192.168.9.219:9300","192.168.9.219:9301","192.168.9.219:9302"]

# 当JVM做分页切换（swapping）时，ElasticSearch执行的效率会降低，推荐把ES_MIN_MEM和ES_MAX_MEM两个环境变量设置成同一个值，并且保证机器有足够的物理内存分配给ES，同时允许ElasticSearch进程锁住内存
bootstrap.memory_lock: true

```

## Index Level Settings

禁用索引的分布式特性，使索引只创建在本地主机上：

```text
#number_of_shards 是指索引要做多少个分片，默认为5，只能在创建索引时指定，后期无法修改。
index.number_of_shards: 5

#number_of_replicas 是指每个分片有多少个副本，后期可以动态修改；如果只有一台机器，设置为0
index.number_of_replicas: 0
```

但随着版本的升级, 不能通过`elasticsearch.yml`对index 进行配置，否则会报错，详见[Elasticsearch常见问题](Elasticsearch-常见问题.md)

只能通过 Call API 去修改 模板

```shell
curl -X PUT "http://localhost:9200/index_name*/_settings" -H 'Content-Type: application/json' -d'
{
    "index" : {
        "number_of_replicas" : 0
    }
}'

curl -X PUT "http://localhost:9200/_all/_settings" -H 'Content-Type: application/json' -d'
{
    "index" : {
        "number_of_replicas" : 0
    }
}'

``` shell

``` shell
curl -H "Content-Type: application/json" -XPUT 'http://localhost:9200/_all/_settings' -d '{
  "index.number_of_shards" : "4"
}'
```

要对后面新的index有效，要创建一个默认模板:

- <https://www.elastic.co/guide/en/elasticsearch/reference/7.9/indices-put-template.html>

``` shell
curl -X PUT "http://localhost:9200/_template/template_name" -H 'Content-Type: application/json' -d'
{
    "index_patterns" : ["filebeat*"],
    "order" : 0,
    "settings" : {
        "number_of_replicas" : 0
    }
}'
```
