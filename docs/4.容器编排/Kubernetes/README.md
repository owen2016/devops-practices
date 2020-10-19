# Kubernetes

Kubernetes 是容器编排管理系统，是一个开源的平台，可以实现容器集群的自动化部署、自动扩缩容、维护等功能。Kubernetes 是Google 2014年创建管理的，是Google 10多年大规模容器管理技术Borg的开源版本。Kubernetes 基本上已经是私有云部署的一个标准。

Kubernets有以下几个特点

- 可移植: 支持公有云，私有云，混合云，多重云（multi-cloud）
- 可扩展: 模块化, 插件化, 可挂载, 可组合
- 自动化: 自动部署，自动重启，自动复制，自动伸缩/扩展

K8s 是将8个字母 “ubernete” 替换为 “8” 的缩写，后续我们将使用 K8s 代替 Kubernetes

## Kubernetes 入门知识点

- Kubernetes 核心概念
- Kubernetes 集群架构
- Kubernetes 集群搭建
  - 从0 搭建一个Kubernetes集群（二进制）
  - 从0 搭建一个Kubernetes集群（Kubeadm）
  - 使用minikube 快速搭建学习
- 在 Kubernetes 部署简单应用
- 理解Pod对象
- 控制器-Deployment 使用
- Serivie 统一入口访问应用
- Ingress 对外暴露应用

## Kubernetes 示例

搭建完k8s集群后，可以使用该示例体会 Kubernetes 的使用

- <https://git.augmentum.com.cn/aug-ops/devops/-/tree/master/k8s/k8s-demo>