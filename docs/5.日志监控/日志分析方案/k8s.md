Fluentd 以 [Kubernetes Daemonset](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) 方式部署在 kubernetes 集群中收集容器日志。

主要有以下yml配置：

* Fluentd ConfigMap  -  [efk/fluentd-es-cm.yml](./efk/fluentd-es-cm.yml)
* Fluentd ServiceAccount - [efk/fluentd-sa.yml](./efk/fluentd-sa.yml)
* Fluentd ClusterRole & ClusterRoleBinding -  [efk/fluentd-rbac.yml](./efk/fluentd-rbac.yml)
* Fluentd DaemonSet - [efk/fluentd-es-ds.yaml](./efk/fluentd-es-ds.yaml)

***
**注意：**
根据实际情况修改 fluentd-es-cm.yml 文件里的 elastic 配置
***

> apply fluentd
```
kubectl apply -f efk/fluentd-es-cm.yml
kubectl apply -f efk/fluentd-sa.yml
kubectl apply -f efk/fluentd-rbac.yml
kubectl apply -f efk/fluentd-es-ds.yaml
```