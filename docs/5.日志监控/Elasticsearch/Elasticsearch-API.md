# Elasticsearch API

API Docs -<https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html>

## 查看集群状态

`curl -X GET "http://localhost:9200/_cat/health"`

## 查看节点

`curl -XGET http://localhost:9200/_nodes/process?pretty`

``` json
{
  "_nodes" : {
    "total" : 1,
    "successful" : 1,
    "failed" : 0
  },
  "cluster_name" : "elasticsearch",
  "nodes" : {
    "iK83cGqrQNiY8vCPiUIhoA" : {
      "name" : "iK83cGq",
      "transport_address" : "172.18.0.4:9300",
      "host" : "172.18.0.4",
      "ip" : "172.18.0.4",
      "version" : "6.8.11",
      "build_flavor" : "default",
      "build_type" : "docker",
      "build_hash" : "00bf386",
      "roles" : [
        "master",
        "data",
        "ingest"
      ],
      "attributes" : {
        "ml.machine_memory" : "16735551488",
        "xpack.installed" : "true",
        "ml.max_open_jobs" : "20",
        "ml.enabled" : "true"
      },
      "process" : {
        "refresh_interval_in_millis" : 1000,
        "id" : 1,
        "mlockall" : false
      }
    }
  }
}
```

## 查看未分片的索引

`curl -XGET http://localhost:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason| grep UNASSIGNED`

## 查看索引

``` text
curl -XGET 'http://192.168.56.121:9200/testindex/_settings?pretty'
{
  "testindex" : {
    "settings" : {
      "index" : {
        "creation_date" : "1589862851550",
        "number_of_shards" : "10",
        "number_of_replicas" : "1",
        "uuid" : "WimYHgHmTQCL0iniMg-Ybw",
        "version" : {
          "created" : "7060299"
        },
        "provided_name" : "testindex"
      }
    }
  }
}
```

## 手动删除这索引

`curl -X DELETE "http://localhost:9200/index_name?pretty"`

返回"acknowledged" : true代表删除成功
