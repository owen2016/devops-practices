# [漫话DevOps]-What is DevOps

> 最近几年"DevOps"这个关键词经常出现在项目开发当中，特别是随着微服务/容器/cloud在项目中的大范围应用，你不想知道都很难。作为一个伴随CI/CD到DevOps一路走来的工程师，我将分几个部分漫话DevOps以及相关的概念，作为软件开发工程师，你需要知道并且开始践行DevOps, 它应该成为你职业素养的一部分。
>
> 笔者是在2015年左右开始听说“DevOps”这个名词，最早听说并实践的一直是CI/CD （后面会介绍它们之间的关系），从CI/CD开始，你会更容易理解DevOps倡导的文化。

## What is DevOps

**DevOps 是一组用于促进开发和运维人员之间协作的过程、方法和系统的统称。**

Wikipedia对DevOps的定义是：
> DevOps是软件开发、运维和质量保证三个部门之间的沟通、协作和集成所采用的流程、方法和体系的一个集合。 它是人们为了及时生产软件产品或服务，以满足某个业务目标，对开发与运维之间相互依存关系的一种新的理解。 ...... DevOps并不仅仅关注软件部署，它是部门间沟通协作的一组流程和方法。

DevOps是Development和Operations的组合，是一种方法论，是一组过程、方法与系统的统称，用于促进应用开发、应用运维和质量保障（QA）部门之间的沟通、协作与整合。以期打破传统开发和运营之间的壁垒和鸿沟  

![image.png](https://upload-images.jianshu.io/upload_images/2504773-f17dbcde022a26c6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "在这里输入图片标题")

从下图中，可以看到Dev 和Ops 关注的点是不同的，并且有各自的利益和关注点，沟通必然存在障碍。**一个想快速迭代，一个想稳定；一个不关心怎么部署运维，一个不清楚开发架构；由此带来的就是效率的低下，以及相互的抱怨，但是完整的项目并不是仅仅代码写完就完事了，质量/稳定/运维才是更重要的。**

![image.png](https://upload-images.jianshu.io/upload_images/2504773-d73cec1ec5d94375.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "在这里输入图片标题")

![输入图片说明](https://upload-images.jianshu.io/upload_images/2504773-d73cec1ec5d94375.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240  "在这里输入图片标题")

DevOps 提倡通过一系列的技术和工具降低开发和运维人员之间的隔阂，实现从开发到最终部署的全流程自动化，从而达到开发运维一体化。通过将 DevOps 的理念引入到整个系统的开发过程中，能够显著提升软件的开发效率，使得各个团队减少时间损耗，更加高效地协同工作，缩短软件交付的周期，更加适应当今快速发展的互联网时代。下面这个DevOps能力图，良好的闭环可以大大增加整体的产出

![image.png](https://upload-images.jianshu.io/upload_images/2504773-41f9cf6dc75492d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## DevOps 与传统开发方式

![image.png](https://upload-images.jianshu.io/upload_images/2504773-2872b6ba8084f3f8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Why is DevOps

猛得听上去，DevOps很抽象，你可能会问以前没有DevOps不是一样开发交付吗？为什么是DevOps?
瀑布开发，敏捷开发都听过吧？DevOps你可以理解为新的开发模型，是文化和技术的方法论，需要公司在组织文化上的变革。

DevOps早在十年前就有人提出来，但是，为什么这两年才开始受到越来越多的企业重视和实践呢？因为DevOps的发展是独木不成林的，现在有越来越多的技术支撑。**微服务架构理念、容器技术使得DevOps的实施变得更加容易，计算能力提升和云环境的发展使得快速开发的产品可以立刻获得更广泛的使用。**
因为技术在发展，项目的开发过程也需要适应新的技术和框架，微服务那么多，容器可能上千个，你怎么快速部署/维护？

![image.png](https://upload-images.jianshu.io/upload_images/2504773-4edf6bd6528faf48.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## DevOps 的好处

- 依托自动化工具把开发、测试、发布、部署的过程整合，实现高度自动化与高效交付。
- 在保证产品质量的前提下快速、频繁地发布产品。
- 能够及时获得用户反馈，并快速响应。
- 最大限度地减少风险，降低代码的出错率。
- 高质量的软件发布标准。整个交付过程标准化、可重复、可靠。
- 整个交付过程进度可视化，方便团队人员了解并控制项目进度。
- 团队协作更高效。

## DevOps 带来的变革

- 角色分工：打破传统团队隔阂，让开发、运维紧密结合，高效协作
- 研发：专注研发、高度敏捷、持续集成
- 产品交付：高质量、快速、频繁、自动化、持续交付

简单的说，**DevOps=团队文化+流程+工具**

团队文化的意思很简单，就是**你的团队要知道并认可DevOps理念**；然后就要通过**具体的流程和工具**来实现这个理念。

后续，我会一点点根据自己的心得体会，慢慢总结分享对DevOps的理解
