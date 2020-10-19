# Elastic-插件

## elasticsearch-head 插件

elasticsearch-head 是用于监控 Elasticsearch 状态的客户端插件，包括数据可视化、执行增删改查操作等

- <https://github.com/mobz/elasticsearch-head>

### 安装 elasticsearch-head

``` shell
wget https://github.com/mobz/elasticsearch-head/archive/master.zip
unzip master.zip
cd elasticsearch-head-master
npm install --registry=http://registry.npm.taobao.org
npm run start

```

安装完通过浏览器访问 <http://localhost:9100>
   ![elasticsearch-head](./images/elasticsearch-head.png)