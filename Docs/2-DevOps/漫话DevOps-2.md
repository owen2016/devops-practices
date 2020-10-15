# [漫话DevOps]- Agile, CI/CD, DevOps

随着DevOps理念的普及与扩散，可能会被一大堆名字概念搞的莫名其妙，理清它们之间的关系可以帮助团队知道DevOps如何落地，改善工作流程。

**Here’s a quick and easy way to differentiate agile, DevOps, and CI/CD:**

- Agile focuses on processes highlighting change while accelerating delivery.
- CI/CD focuses on software-defined life cycles highlighting tools that emphasize automation.
- DevOps focuses on culture highlighting roles that emphasize responsiveness.

![image.png](https://upload-images.jianshu.io/upload_images/2504773-d080c042303e3b84.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Agile Development

- 拥抱变化
- 快速迭代
 ![image.png](https://upload-images.jianshu.io/upload_images/2504773-906788b9c2e462ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
  
## CI /CD

CI/CD 都体现了如今快节奏市场中的文化和发展原则，旨在缩短开发周期、提高软件交付效率以及实现全流程的自动化。同时，两者都有着共同的目标：让软件开发更少地依赖于手动执行的任务，在此基础上使得软件的发布更加频繁、更加安全可靠。由于有着相同的目标，因此持续集成和持续交付并非相互排斥的, 只是它们的应用范围有所不同。

- CI：持续集成（CONTINUOUS INTEGRATION）
- CD：持续部署（CONTINUOUS DEPLOYMENT）
- CD：持续交付（CONTINUOUS DELIVERY）

### 持续集成CI（Continuous Integration）

参考大师的定义: http://www.martinfowler.com/articles/continuousIntegration.html

持续集成（CI）是在源代码变更后自动检测、拉取、构建和（在大多数情况下）进行单元测试的过程

- 对项目而言，持续集成（CI）的目标是确保开发人员新提交的变更是好的， 不会发生break build; 并且最终的主干分支一直处于可发布的状态，

- 对于开发人员而言，要求他们必须频繁地向主干提交代码，相应也可以即时得到问题的反馈。实时获取到相关错误的信息，以便快速地定位与解决问题
  ![image.png](https://upload-images.jianshu.io/upload_images/2504773-064a281aa9596dca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

显然这个过程可以大大地提高开发人员以及整个IT团队的工作效率，避免陷入好几天得不到好的“部署产出”，影响后续的测试和交付。

### 持续交付 （Continuous Delivery）

持续交付在持续集成的基础上，将集成后的代码部署到更贴近真实运行环境的「预发布环境」（production-like environments）中。交付给质量团队或者用户，以供评审。如果评审通过，代码就进入生产阶段 持续交付并不是指软件每一个改动都要尽快部署到产品环境中，它指的是任何的代码修改都可以在任何时候实时部署。
![image.png](https://upload-images.jianshu.io/upload_images/2504773-4cb36753a452ee83.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

强调：
1、手动部署
2、有部署的能力，但不一定部署

### 持续部署（Continuous Deployment）

代码通过评审之后，自动部署到生产环境中。持续部署是持续交付的最高阶段。 

强调
1、持续部署是自动的 
2、持续部署是持续交付的最高阶段 
3、持续交付表示的是一种能力，持续部署则是一种方式
![image.png](https://upload-images.jianshu.io/upload_images/2504773-c2437eaef9c367ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- DEV Development environment -开发环境，用于开发者调试使用
- FAT Feature Acceptance Test environment  -功能验收测试环境，用于软件测试者测试使用
- UAT User Acceptance Test environment  -用户验收测试环境，用于生产环境下的软件测试者测试使用
- PRO Production environment -生产环境

通过CD可以加快软件交付速度，目标用户可以在几天或几周内就收到修复后的功能与新增的功能，而无需等待数月后才更新。CD的部署频率也加快了整个流程中的反馈循环。最新版本真的解决了预期的问题吗？是否满足了用户的需求？用户就可以快速地验收并作出判断，而IT团队也可以在问题影响到开发周期之前就解决反馈的问题。持续的反馈循环使得用户与IT团队更紧密地合作，以确保能准确的理解与满足他们的需求。整个交付过程进度可视化，方便团队人员与客户了解项目的进度。

- 持续集成可确保代码库中始终保持最新的代码，同时可以快速集成来自多个开发人员的代码，并确保这些代码可在多个环境中协同工作。它通常有助于减少错误并通过自动化流程来减少手动任务。CI可以实现代码的自动构建与测试，减少开发中的Bug。因此，CI适用于那些过度依赖手动任务和复杂构建过程的企业。

- 持续交付适用于需要缩短开发周期，更快地为目标用户提供软件的企业。CD降低了部署新软件或升级已有软件的难度，且实现了全流程的自动化，因此您的团队无需手动执行复杂繁琐的任务，从而加快反馈速度，来确保您增加的功能真正地满足用户的需求。

此外，也有不少人认为CI是CD的前提与基础，没有CI就不能实现CD。这种说法也是比较流行的，其思路如下图。因此，不管是哪种说法，CI与CD都是DevOps工具中不可或缺的理念与方法。
![image.png](https://upload-images.jianshu.io/upload_images/2504773-74ab14bc8a196e6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**持续交付与持续部署，到底谁应该包含谁 ?**

持续部署是自动化的将一切变更放到生产环境，而持续交付则有判断决策过程，并直接说“In order to do Continuous Deployment you must be doing Continuous Delivery.”

> “Continuous Delivery is sometimes confused with Continuous Deployment.Continuous Deploymentmeans that every change goes through the pipeline and automatically gets put into production, resulting in many production deployments every day. Continuous Delivery just means that you are able to do frequent deployments but may choose not to do it, usually due to businesses preferring a slower rate of deployment. In order to do Continuous Deployment you must be doing Continuous Delivery.”

对持续交付与持续部署的关系，Martin也承认两个概念容易造成困惑，持续部署代表将所有变更自动通过流水线推到生产环境，持续交付则意味着你有能力这样做，但可以基于业务选择不这样做。

所以我不觉得两者有谁包含谁，两者在这个层面讲，一个是技术领域，一个是业务领域。

### 参考

- [Continuous integration vs. continuous delivery vs. continuous deployment](https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment)

-[Continuous Integration vs. Continuous Delivery](https://dzone.com/articles/continuous-integration-vs-continuous-delivery)

- [The Product Managers’ Guide to Continuous Delivery and DevOps](https://www.mindtheproduct.com/what-the-hell-are-ci-cd-and-devops-a-cheatsheet-for-the-rest-of-us/)

- [What Is DevOps?](https://theagileadmin.com/what-is-devops/)

- [What is CI/CD?](https://www.mabl.com/blog/what-is-cicd)

- [What’s the difference between agile, CI/CD, and DevOps](https://www.synopsys.com/blogs/software-security/agile-cicd-devops-difference/)