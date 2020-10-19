# Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      tier: frontend
    matchExpressions:
      - {key: tier, operator: In, values: [frontend]}
  template:
    metadata:
      labels:
        app: app-demo
        tier: frontend
    spec:
      containers:
      - name: tomcat-demo
        image: tomcat
# 设置资源限额，CPU通常以千分之一的CPU配额为最小单位，用m来表示。通常一个容器的CPU配额被定义为100~300m，即占用0.1~0.3个CPU；
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
```

创建Deployment - `kubectl create -f tomcat-deployment.yaml`

``` text
user@owen-ubuntu:~$ kubectl get deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   1/1     1            1           2m32s

# 注意 这里的名称与Deployment里面名称的关系
user@owen-ubuntu:~$ kubectl get rs
NAME                  DESIRED   CURRENT   READY   AGE
frontend-5955854c9c   1         1         1       2m33s

#Pod的命名以Deployment对应的Replica Set的名字为前缀
user@owen-ubuntu:~$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
frontend-5955854c9c-dw9hj   1/1     Running   0          3m4s

- DESIRED，Pod副本数量的期望值，及Deployment里定义的Replica；
- CURRENT，当前Replica实际值；
- UP-TO-DATE，最新版本的Pod的副本数量，用于指示在滚动升级的过程中，有多少个Pod副本已经成功升级；
- AVAILABLE，当前集群中可用的Pod的副本数量
```