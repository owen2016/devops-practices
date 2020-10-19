# GitLab 目录结构

GitLab 根据安装方式不同（源码/包），配置文件存放位置以及结构也有所不同

## 源码编译安装

配置文件在 /home/git/gitlab/config/*
	
- gitlab.yml - GitLab 配置。

- unicorn.rb - Unicorn web 服务器设置。

- database.yml - 数据库连接设置。

- gitaly.yml - Gitaly 配置. 

- gitlab-shell 的配置文件在 /home/git/gitlab-shell/config.yml。

## apt包安装 （ubuntu）

- 主配置文件: /etc/gitlab/gitlab.rb

- GitLab 文档根目录: /opt/gitlab

- 默认存储库位置: /var/opt/gitlab/git-data/repositories

- GitLab Nginx 配置文件路径:  /var/opt/gitlab/nginx/conf/gitlab-http.conf

- Postgresql 数据目录: /var/opt/gitlab/postgresql/data
