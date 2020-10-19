# Kubernetes 部署方式

- minikube （适用于小白快速搭建单机环境学习K8S）

    Minikube是一个工具，可以在本地快速运行一个单点的Kubernetes，尝试Kubernetes或日常开发的用户使用。不能用于生产环境。

- kubeadm （适用于 了解k8s基本组成、架构之后）

    Kubeadm也是一个工具，提供kubeadm init和kubeadm join指令，用于快速部署Kubernetes集群。(降低部署门槛，但屏蔽了很多细节，遇到问题很难排查)

- 二进制包 （最复杂，适用与对 K8S有一定程度认知）

    从官方下载发行版的二进制包（[和我一步步部署 kubernetes 集群](<https://github.com/opsnull/follow-me-install-kubernetes-cluster>)），手动部署每个组件，组成Kubernetes集群 (虽然手动部署麻烦点，但学习很多工作原理，更有利于后期维护)

---
**强烈建议使用 kubeadm 或者 二进制包 手动搭建K8S集群，中间会遇到很多坑，但同时也有助于你学习K8S！**
