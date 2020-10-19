# Kubernetes 资源对象

1. Cluster: 集群指的是由K8s使用一序列的物理机、虚拟机和其它基础资源来运行你的应用程序。

2. Node: 一个Node就是一个运行着K8s的物理机或虚拟机，并且Pod可以在其上面被调度。

3. Pod: 一个Pod对应一个由相关容器和卷组成的容器组。

4. Label: 一个label是一个被附加到资源上的键值对，比如附加到一个Pod上为它传递一个用户自定的属性，label还可以被应用来组织和选择子网中的资源。

5. Selector: 是一个通过匹配labels来定义资源之间关系的表达式，例如为一个负载均衡的service指定目标Pod。

6. Replication Controller: replication controller 是为了保证Pod一定数量的复制品在任何时间都能正常工作，它不仅允许复制的系统易于扩展，还会处理当Pod在机器重启或发生故障的时候再创建一个。

7. Service: 一个service定义了访问Pod的方式，就像单个固定的IP地址和与其相对应的DNS名之间的关系。

8. Volume: 一个Volume是一个目录。

9. Kubernets Volume: 构建在Docker Volumes之上，并且支持添加和配置Volume目录或者其他存储设备。

10. Secret: Secret存储了敏感数据，例如能运行容器接受请求的权限令牌。

11. Name: 用户为Kubernets中资源定义的名字。

12. Namespace: namespace好比一个资源名字的前缀，帮助不同的项目可以共享cluster，防止出现命名冲突。

13. Annotation: 相对于label来说可以容纳更大的键值对，它对我们来说是不可读的数据，只是为了存储不可识别的辅助数据，尤其是一些被工具或系统扩展用来操作的数据。

## 资源类型缩写

下表列出的是 kubernetes 中所有支持的类型和缩写的别名

|资源类型|缩写别名|
| :-- | :-- |
|clusters| |
|componentstatuses|cs|
configmaps|cm|
daemonsets|ds|
deployments|deploy|
endpoints|ep|
event|ev|
horizontalpodautoscalers|hpa|
ingresses|ing|
jobs| |
limitranges|limits|
namespaces|ns|
networkpolicies| |
nodes|no|
statefulsets| |
persistentvolumeclaims|pvc|
persistentvolumes|pv|
pods|po|
podsecuritypolicies|psp|
podtemplates| |
replicasets|rs|
replicationcontrollers|rc|
resourcequotas|quota|
cronjob||
secrets||
serviceaccount|sa|
services|svc|
storageclasses||
thirdpartyresources||

