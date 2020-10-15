# kubectl

1. [kubernetes node管理](http://www.cnblogs.com/breezey/p/8849472.html#%E7%BB%99%E4%B8%80%E4%B8%AAnode%E6%B7%BB%E5%8A%A0%E4%B8%80%E4%B8%AAlabel)

kubectl cordon k8s-node1    #将k8s-node1节点设置为不可调度模式
kubectl drain k8s-node1     #将当前运行在k8s-node1节点上的容器驱离

kubectl uncordon k8s-node1  #执行完维护后，将节点重新加入调度