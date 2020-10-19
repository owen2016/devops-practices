# Azure AKS

## 连接到群集

`az aks get-credentials --resource-group devops01 --name k8s001`

## AKS 监控

### 用于容器的 Azure Monitor 概述

- <https://docs.microsoft.com/zh-cn/azure/azure-monitor/insights/container-insights-overview>

用于容器的 Azure Monitor 通过 Metrics API 从 Kubernetes 中提供的控制器、节点和容器收集内存和处理器指标，来提供性能可见性。 容器日志也会被收集。 从 Kubernetes 群集启用监视后，将通过适用于 Linux 的 Log Analytics 代理的容器化版本自动收集指标和日志。 指标将写入指标存储区，日志数据将写入与 Log Analytics 工作区关联的日志存储区。

![containers-architecture](./images/azmon-containers-architecture-01.png)

### 利用容器 Azure Monitor 来监视 Kubernetes 群集性能

- <https://docs.microsoft.com/zh-cn/azure/azure-monitor/insights/container-insights-analyze>

### 如何在用于容器的 Azure Monitor 中针对性能问题设置警报

https://docs.microsoft.com/zh-cn/azure/azure-monitor/insights/container-insights-alerts

### 创建指标报警

- <https://docs.microsoft.com/zh-cn/azure/azure-monitor/insights/container-insights-metric-alerts>

### 创建日志警报

- <https://docs.microsoft.com/zh-cn/azure/azure-monitor/insights/container-insights-log-alerts>

### 如何从用于容器的 Azure Monitor 查询日志

- <https://docs.microsoft.com/zh-cn/azure/azure-monitor/insights/container-insights-log-search>