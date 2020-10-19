# Minikube

[TOC]

## 介绍

- <https://minikube.sigs.k8s.io/docs/>

Minikube 用于快速在本地搭建 Kubernetes 单节点集群环境，它对硬件资源没有太高的要求，方便开发人员学习试用，或者进行日常的开发。

其支持大部分kubernetes的功能，列表如下

- DNS
- NodePorts
- ConfigMaps and Secrets
- Dashboards
- Container Runtime: Docker, and rkt
- Enabling CNI (Container Network Interface)
- Ingress

[minikube](https://github.com/kubernetes/minikube)原本是用于在开发环境快速安装 K8s 的工具，由于 Docker 需要系统为 Linux 且内核支持[LXC](https://linuxcontainers.org/)，因此在 Windows、macOS 下目前都是通过虚拟机来实现 Docker 的安装及运行的。而 Minikube 支持 Windows、macOS、Linux 三种 OS，会根据平台不同，下载对应的虚拟机镜像，并在镜像内安装 k8s。

目前的虚拟机技术都是基于[Hypervisor](https://en.wikipedia.org/wiki/Hypervisor) 来实现的，Hypervisor 规定了统一的虚拟层接口，由此 Minikube 就可以无缝切换不同的虚拟机实现，如 macOS 可以切换[hyperkit](https://github.com/moby/hyperkit) 或 VirtualBox， Windows 下可以切换 [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) 或 VirtualBox 等。

虚拟机的切换可以通过 --vm-driver 实现，如
`minikube start --vm-driver hyperkit/ minikube start --vm-driver hyperv`

将会运行一个单节点的Kubernetes集群。Minikube也已经把kubectl配置好，因此无需做额外的工作就可以管理容器。
Minikube 创建一个Host-Only（仅主机模式）网络接口，通过这个接口可以路由到节点。如果要与运行的pods或services进行交互，你应该通过这个地址发送流量。使用 `minikube ip` 命令可以查看这个地址：

## Minikube 安装

### 下载Minikube

- <https://kubernetes.io/docs/tasks/tools/install-minikube/>

`curl -Lo minikube https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.13.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/`

- <https://kubernetes.io/docs/tasks/tools/install-kubectl/>

`curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/`

### 启动Minikube

启动minikube：minikube start

默认启动使用的是 VirtualBox 驱动，使用 --vm-driver 参数可以指定其它驱动

``` text
- --image-mirror-country cn 将缺省利用 registry.cn-hangzhou.aliyuncs.com/google_containers 作为安装Kubernetes的容器镜像仓库，

- --iso-url=*** 利用阿里云的镜像地址下载相应的 .iso 文件
- --cpus=2: 为minikube虚拟机分配CPU核数
- --memory=2000mb: 为minikube虚拟机分配内存数
- --kubernetes-version=***: minikube 虚拟机将使用的 kubernetes 版本 ,e.g. --kubernetes-version v 1.17.3
- --docker-env http_proxy 传递代理地址

https://minikube.sigs.k8s.io/docs/drivers/
- --vm-driver=none 表示用容器；
- --vm-driver=virtualbox 表示用虚拟机；

```

#### 示例

##### --vm-driver=kvm2 (推荐使用)

参考: <https://minikube.sigs.k8s.io/docs/drivers/kvm2/>

`minikube start --image-mirror-country cn  --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers --registry-mirror=https://ovfftd6p.mirror.aliyuncs.com --driver=kvm2`

##### --vm-driver=none

`sudo minikube start --image-mirror-country cn --vm-driver=none`

![minikube install](./images/minikube-install.png)

`sudo minikube start --vm-driver=none  --docker-env http_proxy=http://$host_IP:8118 --docker-env https_proxy=https:// $host_IP:8118`

其中$host_IP指的是host的IP，可以通过ifconfig查看

比如在我这台机器是10.0.2.15，用virtualbox部署，则用下列命令启动minikube

`sudo minikube start --vm-driver=none  --docker-env http_proxy=http://10.0.2.15:8118 --docker-env https_proxy=https://10.0.2.15:8118`

![minikube-status](./images/minikube-status.png)

## Minikube 使用

用户使用Minikube CLI管理虚拟机上的Kubernetes环境，比如：启动，停止，删除，获取状态等。

一旦Minikube虚拟机启动，用户就可以使用熟悉的Kubectl CLI在Kubernetes集群上执行操作

``` text
# 查看集群的所有资源
kubectl get all

# 进入节点服务器
minikube ssh

# 执行节点服务器命令，例如查看节点 docker info
minikube ssh -- docker info

# 删除集群, 删除 ~/.minikube 目录缓存的文件
minikube delete

# 关闭集群
minikube stop

## 销毁集群
minikube stop && minikube delete
```

Minikube 默认集成了 Kubernetes Dashboard。执行 `minikube dashboard` 命令后，默认会打开浏览器

![minikube-dashboard](./images/minikube-dashboard.png)