# kubernetes+Prometheus3

我们的整套监控系统采用的方案就是kubernetes+Prometheus集成：

* Prometheus集群内部署
* Prometheus集成[Alertmanager](https://prometheus.io/docs/alerting/overview/)实现报警提醒
* [Prometheus exporter](https://prometheus.io/docs/instrumenting/exporters/) 和 push metrics 方式收集metric data, 其中node-exporter 以kubernetes Daemonset 方式部署在集群中
* Prometheus集成Grafana实现可视化界面展示

同时我们使用 [Prometheus Operator](https://coreos.com/operators/prometheus/docs/latest/user-guides/getting-started.html) 在Kubernetes中创建/配置/管理Prometheus集群和Alertmanager集群。

Prometheus Operator主要包括以下三类资源：
* Prometheus
* Alertmanager
* ServiceMonitor - 描述由Prometheus监控的目标集

Prometheus Operator整个架构组成如下图：
![Prometheus_operator](https://coreos.com/operators/prometheus/docs/latest/user-guides/images/architecture.png)

通过以下方式监控kubernetes 核心组件资源：

* kubernetes集群状态通过`kube-state-metrics`
* kubernetes机器节点状态通过`node_exporter`
* kubelets
* apiserver
* kube-scheduler
* kube-controller-manager