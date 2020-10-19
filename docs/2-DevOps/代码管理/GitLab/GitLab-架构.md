# GitLab 架构

GitLab 是一个利用Ruby on Rails 开发的开源版本控制系统，实现一个自托管的Git项目仓库，可通过Web界面进行访问公开的或者私人项目。

GitLab由以下服务构成

- nginx: 静态web服务器

- gitlab-shell: 用于处理Git命令和修改authorized keys列表

- gitlab-workhorse: 轻量级的反向代理服务器

- logrotate：日志文件管理工具

- postgresql：数据库

- redis：缓存数据库

- sidekiq：用于在后台执行队列任务（异步执行）

- unicorn：An HTTP server for Rack applications，GitLab Rails应用是托管在这个服务器上面的。

## Simplified Component Overview

![architecture_simplified](./images/architecture_simplified.png)

Gitlab通常安装在GNU/Linux上。使用Nignx或Apache 作为Web前端将请求代理到Unicorn Web 服务器

默认情况下，Unicorn 与前端之间的通信是通过 Unix domain 套接字进行的，但也支持通过 TCP 转发请求。Web 前端访问 /home/git/gitlab/public 绕过 Unicorn 服务器来提供静态页面，上传（例如头像图片或附件）和预编译资源。GitLab 使用 Unicorn Web 服务器提供网页和 GitLab API。使用 Sidekiq 作为作业队列，反过来，它使用 redis 作为作业信息，元数据和作业的非持久数据库后端。

GitLab 应用程序使用 MySQL 或 PostgreSQL 作为持久数据库，保存用户，权限，issue，其他元数据等，默认存储在 /home/git/repositories 中提供的 git repository。

通过 HTTP/HTTPS 提供 repository 时，GitLab 使用 GitLab API 来解析授权和访问以及提供 git 对象。

gitlab-shell 通过 SSH 提供 repository。它管理 /home/git/.ssh/authorized_keys 内的 SSH 密钥，不应手动编辑。gitlab-shell 通过 Gitaly 访问 bare repository 以提供 git 对象并与 redis 进行通信以向 Sidekiq 提交作业以供 GitLab 处理。gitlab-shell 查询 GitLab API 以确定授权和访问。

Gitaly 从 gitlab-shell 和 GitLab web 应用程序执行 git 操作，并为 GitLab web 应用程序提供 API 以从 git 获取属性（例如 title，branches，tags，其他元数据）和 blob（例如 diffs，commits ，files）
