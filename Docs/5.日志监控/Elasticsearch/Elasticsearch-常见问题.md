# Elasticsearch 常见问题

## 问题1 - node settings must not contain any index level settings

```text
*************************************************************************************,
Found index level settings on node level configuration.,
,
Since elasticsearch 5.x index level settings can NOT be set on the nodes ,
configuration like the elasticsearch.yaml, in system properties or command line ,
arguments.In order to upgrade all indices the settings must be updated via the ,
/${index}/_settings API. Unless all settings are dynamic all indices must be closed ,
in order to apply the upgradeIndices created in the future should use index templates ,
to set default values. ,
,
Please ensure all required values are updated on all indices by executing: ,
,
curl -XPUT 'http://localhost:9200/_all/_settings?preserve_existing=true' -d '{,
  "index.number_of_replicas" : "0",
}',
*************************************************************************************,
,
[2020-09-15T07:11:00,688][WARN ][o.e.b.ElasticsearchUncaughtExceptionHandler] [es_node_0] uncaught exception in thread [main],
org.elasticsearch.bootstrap.StartupException: java.lang.IllegalArgumentException: node settings must not contain any index level settings,

```

## 问题-2 bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]

原因：最大虚拟内存太小

在`/etc/sysctl.conf` 中加入如下内容： `vm.max_map_count=262144`

启用配置：`sysctl -p`

## 问题-3 Can't update non dynamic settings

`curl -XPOST 'http://localhost:9200/_all/_close'`

关闭索引，再更新之后再打开
