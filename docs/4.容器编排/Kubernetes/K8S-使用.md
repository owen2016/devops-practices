


Istio:
* 数据平面
* 控制平面
* Envoy
* Mixer
* Pilot
* Citadel

Istio Tasks:
* 流量管理
* * Gateway
* * VirtualService
* * DestinationRule
* * ServiceEntry
* * Policy
* 安全
* * ServiceRole
* * ServiceRoleBinding
* * Policy
* 策略
* * memquota
* * quota
* * rule
* * QuotaSpec
* * QuotaSpecBinding
* * listchecker
* * listentry
* * rule
* 遥测
* * zipkin
* * jaeger
* * servicegraph
* * prometheus

-----------------------------------------------------
### K8S & Istio Install
K8s + Istio 集群搭建请参考[kubernetes集群, Istio安装](../tools-setup-1ane6lq6t6dip.md)
或者通过ansible自动化安装，请参考[Ansible自动化部署](../tools-setup-1b15bidsn62vn.md)

### K8S Infrastructure Architecture
![](http://172.20.48.231:8181/uploads/tools-setup/images/m_5b9c121413a9450c811d958b6f7ee826_r.png)

### K8S Service Distribute
![](http://172.20.48.231:8181/uploads/tools-setup/images/m_67597f95f5ecafbf421804607ca2e8ca_r.png)

![](http://172.20.48.231:8181/uploads/tools-setup/images/m_06c84571da84ff8d90e31ebf38a3f195_r.png)

### K8s 须知
* 某些服务是固定到特定机器上的
* * Easticsearch
* * Prometheus
* Pod基本是三种类型配置启动的
* * Deployment
* * Statefulset
* * Daemonset
* 服务配置文件尽量用Configmap的方式配置在K8s中，尽量少采用文件挂载
* 服务数据需要持久化存储的，用PersistentVolume持久化出来
* 主体服务应该都要配置健康检查和资源限制


### Istio 须知
* 添加域名需要配置Gateway
* 子服务解析需要配置VirtualService
* 服务之间访问通过服务名称访问
* 外部服务访问需要配置ServiceEntry

### Service 访问
![](http://172.20.48.231:8181/uploads/tools-setup/images/m_549c2e3a5fa85521dd3303ff2fed3be8_r.png)

### Devops 
![](http://172.20.48.231:8181/uploads/tools-setup/images/m_1468aebd56d29d0600eff2b0ddaae57f_r.png)