# Service

Service定义了一个Pod的逻辑集合和访问这个集合的策略。集合是通过定义Service时提供的Label选择器完成的。

举个例子，我们假定有3个Pod的备份来完成一个图像处理的后端。这些后端备份逻辑上是相同的，前端不关心哪个后端在给它提供服务。虽然组成这个后端的实际Pod可能变化，前端客户端不会意识到这个变化，也不会跟踪后端。Service就是用来实现这种分离的抽象

## 定义一个Service

``` yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    name: mysql
    role: service
  name: mysql-service
spec:
  ports:
    - port: 3306
      targetPort: 3306
      nodePort: 30964
  type: NodePort
  selector:
    mysql-service: "true"
```

上述内容定义了一个名为“mysql-service”的Servcie，它的服务端口为8080，拥有 “mysql-service=true”这个Label的所有Pod实例都属于它；当访问node上的30964端口时，其请求会转发到service对应的cluster IP的3306端口，并进一步转发到pod的3306端口

查看service更多信息

`kubectl get svc tomcat-service -o yaml`

## 发布服务 -Service类型

![service-type](./images/service-type.png)

Kubernetes的ServiceTypes能让你指定你想要哪一种服务。

- 默认的和基础的是ClusterIP，这会开放一个服务可以在`集群内部进行连接`。
- NodePort 和LoadBalancer是两种会`将服务开放给外部网络的类型`。

ServiceType字段的合法值是：

1. ClusterIP: 仅仅使用一个集群内部的IP地址 - 这是默认值。选择这个值意味着你只想这个服务在集群内部才可以被访问到。

2. NodePort: 在集群内部IP的基础上，在集群的每一个节点的端口上开放这个服务。你可以在任意 `<NodeIP>:NodePort`地址上访问到这个服务。

3. LoadBalancer: 在使用一个集群内部IP地址和在NodePort上开放一个服务之外，向云提供商申请一个负载均衡器，会让流量转发到这个在每个节点上以`<NodeIP>:NodePort`的形式开放的服务上。
