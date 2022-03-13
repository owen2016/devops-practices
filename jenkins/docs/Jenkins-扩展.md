# 扩展 Jenkins

Jenkins是一个可扩展的自动化服务器，拥有超过1000个插件，可提供数百种工具和服务的集成。以下的内容将介绍如何 扩展 Jenkins的功能和开发一个Jenkins插件.

## 插件教程

- 本教程是 Jenkins 插件开发的起点：它解释了如何准备您的构建环境，如何创建插件以及如何实现通用功能

https://www.jenkins.io/zh/doc/developer/tutorial/

一些比较明显的扩展点包括 SCM implementations：将 Git、Subversion 或 Perforce 等 SCM 集成到 Jenkins 中; build steps：提供从方便的用户界面到配置构建工具、到发送电子邮件等所有内容; 还有 authentication realms：将 Jenkins 与单点登录系统或外部用户目录（如 LDAP 或 Active Directory）集成。

但接下来的更加强大：Job types — 流水线在插件中实现; annotating console output or changelogs：例如，在问题跟踪器中添加链接把错误引入; 影响 Jenkins build queue 优先考虑队列项目并将构建分配给代理; 或者添加 node monitors，Jenkins 作为度量提供者定期查询以确定每个构建节点的健康状况等都可以使用插件中的扩展来完成。 这些仅仅是 Jenkins 中扩展点的几个例子。

本教程是 Jenkins 插件开发的起点：它解释了如何准备您的构建环境，如何创建插件以及如何实现通用功能

## Jenkins Core

This is the Javadoc for Jenkins core. Multiple versions are available: The latest weekly release, as well as the most recent LTS baselines. Unless a plugin requires very recent functionality, it should generally use one of the LTS baselines for its Jenkins core dependency

https://www.jenkins.io/zh/doc/developer/javadoc/

## Extensions Index

Jenkins defines extension points, which are interfaces or abstract classes that model an aspect of its behavior. Those interfaces define contracts of what need to be implemented, and Jenkins allows plugins to contribute those implementations. In general, all you need to do to register an implementation is to mark it with @Extension. Creating a new extension point is quite easy too, see [defining a new extension point](https://wiki.jenkins.io/display/JENKINS/Defining+a+new+extension+point) for details.

大概就是说 jenkins core 留了接口，同时插件开发也可以预留接口，其他插件可以实现

## 参考文档

介绍 Jenkins 的各种特性和知识。

https://www.jenkins.io/zh/doc/developer/book/