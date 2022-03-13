# Jenkins Pipeline

Jenkins 1.0 只能通过UI界面手动操作来“描述”流水线; Jenkins 2.0 开始支持pipeline as code.

参考：https://blog.csdn.net/diantun00/article/details/81075007

Pipeline，简而言之，就是一套运行于Jenkins上的工作流框架，将原本独立运行于单个或者多个节点的任务连接起来，
实现单个任务难以完成的复杂流程编排与可视化

Pipeline是Jenkins2.X的最核心的特性，帮助Jenkins实现从CI到CD与DevOps的转变

Pipeline是一组插件，让Jenkins可以实现持续交付管道的落地和实施。

持续交付管道（CD Pipeline）是将软件从版本控制阶段到交付给用户或客户的完整过程的自动化表现。软件的每一次更改
（提交到源代码管理系统）都要经过一个复杂的过程才能被发布。

Stage：阶段，一个Pipeline可以划分成若干个Stage，每个Stage代表一组操作，例如：“Build”，“Test”，“Deploy”。
    注意，Stage是一个逻辑分组的概念，可以跨多个Node

Pipeline五大特性
    代码:Pipeline以代码的形式实现，通常被检入源代码控制，使团队能够编辑、审查和迭代其CD流程。
    可持续性：Jenklins重启或者中断后都不会影响Pipeline Job。
    停顿：Pipeline可以选择停止并等待任工输入或批准，然后再继续Pipeline运行。
    多功能：Pipeline支持现实世界的复杂CD要求，包括fork/join子进程，循环和并行执行工作的能力
    可扩展：Pipeline插件支持其DSL的自定义扩展以及与其他插件集成的多个选项。

Pipeline和Freestyle的区别
    Freestyle：
        上游/下游Job调度，如
        BuildJob —> TestJob —> DeployJob
        在DSL Job里面调度多个子Job（利用Build Flow Plugin）

    Pipeline：
        单个Job中完成所有的任务编排
        全局视图

    Multibranch Pipeline根据你的代码中Jenlinsfile自动创建Job
        ＊＊＊＊执行的时候会多分支同时部署＊＊＊

Jenlins Pipeline的基础语法
    Pipeline脚本是由Groovy语言实现（无需专门学习）

    支持两种语法
        Declarative 声明式（在Pipeline plugin 2.5中引入）
        Scripted Pipeline 脚本式

## Pipeline 使用

语法参考： https://jenkins.io/zh/doc/book/pipeline/syntax/

步骤参考： https://jenkins.io/zh/doc/pipeline/steps/

## Pipeline 代码片段生成

- pipeline-syntax

## jenkinsfile 校验

- Jenkins Pipeline Linter Connector (vscode 插件)

## Pipeline 开发参考&原则
