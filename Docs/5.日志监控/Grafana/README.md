# Grafana

[Grafana](http://docs.grafana.org/guides/getting_started/) 是开源软件工具，实时收集、存储和显示时间序列数据。无论您的数据在哪里，或者它位于什么样的数据库中，都可以将它与Grafana组合在一起，展示非常漂亮的可视化界面。

grafana是一个优秀的数据看板类工具，他提供了强大和优雅的方式去创建、共享、浏览数据。dashboard中显示了你不同metric数据源中的数据。

Grafana是在网络架构和应用分析中最流行的时序数据展示工具，并且也在工业控制、自动化监控和过程管理等领域有着广泛的应用

grafana有热插拔控制面板和可扩展的数据源，目前已经支持绝大部分常用的时序数据库

## Docker部署Grafana

``` shell
docker run -d \
        -p 3000:3000 \
        --name grafana \
        -v /opt/mount/grafana/dir/grafana:/usr/share/grafana \
        -v /opt/mount/grafana/data/grafana:/var/lib/grafana \
        grafana/grafana

```