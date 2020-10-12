# k8s deployment

## k8s-ubuntu18

k8s-install.sh 需要在每台机器上面执行，如何初始化k8s集群，以及如何添加节点到k8s集群中，可以根据https://blog.csdn.net/shykevin/article/details/98811021文章进行操作，但是文章中有一个地方需要注意，

`sudo kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.15.2 --pod-network-cidr=192.169.0.0/16`

 这里的pod-network-cidr使用的192.169.0.0，所以在添加calico网络插件的时候，需要修改calico配置文件（http://mirror.faasx.com/k8s/calico/v3.3.2/calico.yaml）

```
- name: CALICO_IPV4POOL_CIDR
  value: "192.168.0.0/16"
```

修改为：

```
- name: CALICO_IPV4POOL_CIDR
  value: "192.169.0.0/16"
```
否则，容器将无法访问外网。

gpu插件采用的是nvidia-device-plugin，如下：

`kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/master/nvidia-device-plugin.yml`

参考文档如下：https://feisky.gitbooks.io/kubernetes/content/plugins/device.html