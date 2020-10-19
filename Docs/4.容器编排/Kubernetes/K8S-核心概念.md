
# 核心概念

## 1.Master

k8s集群的管理节点，负责管理集群，提供集群的资源数据访问入口。拥有Etcd存储服务（可选），运行Api Server进程，Controller Manager服务进程及Scheduler服务进程，关联工作节点Node。

- Kubernetes API server 提供HTTP Rest接口的关键服务进程，是Kubernetes里`所有资源的增、删、改、查等操作的唯一入口`。也是集群控制的入口进程；

- Kubernetes Controller Manager 是Kubernetes `所有资源对象的自动化控制中心`；
  
- Kubernetes Schedule 是`负责资源调度`（Pod调度）的进程

- etcd Server，Kubernetes里 所有的资源对象的数据全部是保存在etcd中

## 2、Node

Node作为集群中的工作节点，运行真正的应用程序，用来承载被分配Pod的运行，是Pod运行的宿主机，`在Node上Kubernetes 管理的最小运行单元是Pod`。

**每个Node节点都运行着以下一组关键进程:**

- kubelet：负责对Pod对于的容器的创建、启停等任务

- kube-proxy：实现K8S Service的通信与负载均衡机制的重要组件

- Docker Engine（Docker）：Docker引擎，负责本机容器的创建和管理工作

Node节点可以在运行期间动态增加到Kubernetes集群中，默认情况下，kubelet会向master注册自己，这也是Kubernetes推荐的Node管理方式，kubelet进程会定时向Master汇报自身情报，如操作系统、Docker版本、CPU和内存，以及有哪些Pod在运行等等，这样Master可以获知每个Node节点的资源使用情况，并实现高效均衡的资源调度策略。

## 3、Pod

`Pod是Kurbernetes进行创建、调度和管理的最小单位`，它提供了比容器更高层次的抽象，使得部署和管理更加灵活。一个Pod可以包含一个容器或者多个相关容器。

由于不能将多个进程聚集在一个单独容器，需要另外一种高级结构将容器绑定在一起，作为一个单元管理，这就是Pod背后根本原理， 一个pod中容器共享相同ip和端口空间

普通Pod一旦被创建，就会被放入etcd存储中，随后会被Kubernetes Master调度到摸个具体的Node上进行绑定，随后该Pod被对应的Node上的kubelet进程实例化成一组相关的Docker容器并启动起来，在。在默认情况下，当Pod里的某个容器停止时，Kubernetes会自动检测到这个问起并且重启这个Pod（重启Pod里的所有容器），如果Pod所在的Node宕机，则会将这个Node上的所有Pod重新调度到其他节点上。

![k8s-1](./images/k8s-基础-1.jpg)

同一个Pod里的容器共享同一个网络命名空间，可以使用localhost互相通信。

**一个Pod中的应用容器共享同一组资源：**

- PID命名空间：Pod中的不同应用程序可以看到其他应用程序的进程ID；

- 网络命名空间：Pod中的多个容器能够访问同一个IP和端口范围；

- IPC命名空间：Pod中的多个容器能够使用SystemV IPC或POSIX消息队列进行通信；

- UTS命名空间：Pod中的多个容器共享一个主机名；

- Volumes（共享存储卷）：Pod中的各个容器可以访问在Pod级别定义的Volumes；

Pod是短暂的，不是持续性实体。你可能会有这些问题：如果Pod是短暂的，那么我怎么才能持久化容器数据使其能够跨重启而存在呢？ 是的，Kubernetes支持卷的概念，因此可以使用持久化的卷类型。

Pod的生命周期通过Replication Controller来管理；通过模板进行定义，然后分配到一个Node上运行，在Pod所包含容器运行结束后，Pod结束。

如果Pod是短暂的，那么重启时IP地址可能会改变，那么怎么才能从前端容器正确可靠地指向后台容器呢？这时可以使用Service，下文会详细介绍。

Kubernetes为Pod设计了一套独特的网络配置，包括：为每个Pod分配一个IP地址，使用Pod名作为容器间通信的主机名等。

## 4、RC（Replication Controller）

Replication Controller用来管理Pod的副本，保证集群中存在指定数量的Pod副本。集群中副本的数量大于指定数量，则会停止指定数量之外的多余容器数量，反之，则会启动少于指定数量个数的容器，保证数量不变。Replication Controller是实现弹性伸缩、动态扩容和滚动升级的核心。

在Kubernetes集群中，它解决了传统IT系统中服务扩容和升级的两大难题。你只需为需要扩容的Service关联的Pod创建一个Replication Controller简称（RC），则该Service的扩容及后续的升级等问题将迎刃而解。在一个RC定义文件中包括以下3个关键信息。

- 目标Pod的定义；
- 目标Pod需要运行的副本数量；
- 要监控的目标Pod标签（Lable）；

Kubernetes通过RC中定义的Lable筛选出对应的Pod实例，并实时监控其状态和数量，如果实例数量少于定义的副本数量（Replicas），则会根据RC中定义的Pod模板来创建一个新的Pod，然后将此Pod调度到合适的Node上启动运行，直到Pod实例数量达到预定目标，这个过程完全是自动化的。

是否手动创建Pod，如果想要创建同一个容器的多份拷贝，需要一个个分别创建出来么，能否将Pods划到逻辑组里？

Replication Controller确保任意时间都有指定数量的Pod“副本”在运行。如果为某个Pod创建了Replication Controller并且指定3个副本，它会创建3个Pod，并且持续监控它们。如果某个Pod不响应，那么Replication Controller会替换它，保持总数为3.

如果之前不响应的Pod恢复了，现在就有4个Pod了，那么Replication Controller会将其中一个终止保持总数为3。如果在运行中将副本总数改为5，Replication Controller会立刻启动2个新Pod，保证总数为5。还可以按照这样的方式缩小Pod，这个特性在执行滚动升级时很有用。

当创建Replication Controller时，需要指定两个东西：

- Pod模板：用来创建Pod副本的模板
- Label：Replication Controller需要监控的Pod的标签。

现在已经创建了Pod的一些副本，那么在这些副本上如何均衡负载呢？我们需要的是Service。

## 5、Service

虽然每个Pod都会被分配一个单独的IP地址，但这个IP地址会随着Pod的销毁而消失，这就引出一个问题：`如果有一组Pod组成一个集群来提供服务，那么如何来访问它呢？Service！`

如果Pods是短暂的，那么重启时IP地址可能会改变，怎么才能从前端容器正确可靠地指向后台容器呢？

一个Service可以看作一组提供相同服务的Pod的对外访问接口，Service作用于哪些Pod是通过Label Selector来定义的。

- 拥有一个指定的名字（比如my-mysql-server）；

- 拥有一个虚拟IP（Cluster IP、Service IP或VIP）和端口号，销毁之前不会改变，只能内网访问；

- 能够提供某种远程服务能力；
  
- 被映射到了提供这种服务能力的一组容器应用上；

**外部系统访问Service的问题?**

首先需要弄明白Kubernetes的三种IP这个问题

- Node IP：Node节点的IP地址
- Pod IP： Pod的IP地址
- Cluster IP：Service的IP地址

首先,Node IP是Kubernetes集群中节点的物理网卡IP地址，所有属于这个网络的服务器之间都能通过这个网络直接通信。这也表明Kubernetes集群之外的节点访问Kubernetes集群之内的某个节点或者TCP/IP服务的时候，必须通过Node IP进行通信

其次，Pod IP是每个Pod的IP地址，他是Docker Engine根据docker0网桥的IP地址段进行分配的，通常是一个虚拟的二层网络。

最后Cluster IP是一个虚拟的IP，但更像是一个伪造的IP网络，原因有以下几点

- Cluster IP仅仅作用于Kubernetes Service这个对象，并由Kubernetes管理和分配P地址
  
- Cluster IP无法被ping，他没有一个“实体网络对象”来响应
  
- Cluster IP只能结合Service Port组成一个具体的通信端口，单独的Cluster IP不具备通信的基础，并且他们属于Kubernetes集群这样一个封闭的空间。

`如果Service要提供外网服务，需指定 公共IP和 NodePort，或外部负载均衡器；`

Service定义了Pod的逻辑集合和访问该集合的策略，是真实服务的抽象。Service提供了一个统一的服务访问入口以及服务代理和发现机制，关联多个相同Label的Pod，用户不需要了解后台Pod是如何运行。

现在，假定有2个后台Pod，并且定义后台Service的名称为‘backend-service’，lable选择器为（tier=backend, app=myapp）。backend-service 的Service会完成如下两件重要的事情：

- 会为Service创建一个本地集群的DNS入口，因此前端Pod只需要DNS查找主机名为 ‘backend-service’，就能够解析出前端应用程序可用的IP地址。

- 现在前端已经得到了后台服务的IP地址，但是它应该访问2个后台Pod的哪一个呢？Service在这2个后台Pod之间提供透明的负载均衡，会将请求分发给其中的任意一个，通过每个Node上运行的代理（kube-proxy）完成。这里有更多技术细节。

## 6、Volume

Volume是Pod中能够被多个容器访问的共享目录。

## 7、Label

容器提供了强大的隔离功能，所有有必要把为Service提供服务的这组进程放入容器中进行隔离。为此，Kubernetes设计了Pod对象，将每个服务进程包装到相对应的Pod中，使其成为Pod中运行的一个容器。为了建立Service与Pod间的关联管理，Kubernetes给每个Pod贴上一个标签Label，比如运行MySQL的Pod贴上name=mysql标签，给运行PHP的Pod贴上name=php标签，然后给相应的Service定义标签选择器Label Selector，这样就能巧妙的解决了Service于Pod的关联问题。

Kubernetes中的任意API对象都是通过Label进行标识，Label的实质是一系列的Key/Value键值对，其中key于value由用户自己指定。Label可以附加在各种资源对象上，如Node、Pod、Service、RC等，一个资源对象可以定义任意数量的Label，同一个Label也可以被添加到任意数量的资源对象上去。Label是Replication Controller和Service运行的基础，二者通过Label来进行关联Node上运行的Pod。

我们可以通过给指定的资源对象捆绑一个或者多个不同的Label来实现多维度的资源分组管理功能，以便于灵活、方便的进行资源分配、调度、配置等管理工作。
一些常用的Label如下：

- 版本标签："release":"stable","release":"canary"......
- 环境标签："environment":"dev","environment":"qa","environment":"production"
- 架构标签："tier":"frontend","tier":"backend","tier":"middleware"
- 分区标签："partition":"customerA","partition":"customerB"
- 质量管控标签："track":"daily","track":"weekly"

Label相当于我们熟悉的标签，给某个资源对象定义一个Label就相当于给它大了一个标签，随后可以通过Label Selector（标签选择器）查询和筛选拥有某些Label的资源对象，Kubernetes通过这种方式实现了类似SQL的简单又通用的对象查询机制。

**Label Selector在Kubernetes中重要使用场景如下:**

- kube-Controller进程通过资源对象RC上定义Label Selector来筛选要监控的Pod副本的数量，从而实现副本数量始终符合预期设定的全自动控制流程

- kube-proxy进程通过Service的Label Selector来选择对应的Pod，自动建立起每个Service岛对应Pod的请求转发路由表，从而实现Service的智能负载均衡

- 通过对某些Node定义特定的Label，并且在Pod定义文件中使用Nodeselector这种标签调度策略，kuber-scheduler进程可以实现Pod”定向调度“的特性

## 8、Replica Set

下一代的Replication Controlle，Replication Controlle 只支持基于等式的selector（env=dev或environment!=qa）但Replica Set还支持新的、基于集合的selector（version in (v1.0, v2.0)或env notin (dev, qa)），这对复杂的运维管理带来很大方便。