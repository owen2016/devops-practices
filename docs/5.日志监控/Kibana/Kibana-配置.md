# Kibana-配置 (kibana.yml)

- <https://www.elastic.co/guide/en/kibana/current/settings.html>

`/usr/share/kibana/config/kibana.yml`

``` yml
# The host to bind the server to.
host: "0.0.0.0"

# The Elasticsearch instance to use for all your queries.
elasticsearch_url: "http://localhost:9200"

#中文设置
i18n.locale: zh-CN
#注意, 上面冒号: 和 zhe-CN 之间必须有个空格，否则kibana无法启动

```
