# HorizontalPodAutoscaler

``` yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
  namespace: default
spec:
  maxReplicas: 10
  minReplicas: 1
  scaleTargetRef:
    kind: Deployment
    name: php-apache
  targetCPUUtilizationPercentage: 90
```

这个HPA控制的目标对象为一个名叫php-apache的Deployment里的Pod副本，当这些Pod副本的CPUUtilizationPercentage超过90%时会触发自动扩容行为，扩容或缩容时必须满足的一个约束条件是Pod的副本数要介于1与10之间；

命令方式实现相同的功能
`kubectl autoscale deployment php-apache –cpu-percent=90 –min=1 –max=10`