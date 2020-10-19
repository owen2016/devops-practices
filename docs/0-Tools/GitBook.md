# 使用私有gitlab搭建gitbook持续集成

[TOC]

在项目实践中，团队需要对用到的知识技术进行总结，即便于分享，也利于传承，而gitbook就是个不错的选择，使用gitbook-cli 对Markdown文档进行编译，生成静态文件，再通过web服务器（e.g. nginx）对外提供服务。

gitbook和gitlab搭建持续集成，可实现文档的即时更新，这也是我在DevOps实践的一部分。

- <https://www.gitbook.com>

- <https://github.com/GitbookIO/gitbook>

![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201016234543.png)

## 环境搭建

### 1. 安装 Node.js

gitbook 是一个基于 Node.js 的命令行工具，下载安装 [Node.js](https://nodejs.org/en/)，安装完成之后，你可以使用下面的命令来检验是否安装成功。

`$ node -v`

### 2. 安装 gitbook

输入下面的命令来安装 gitbook

`npm install gitbook-cli -g`

安装完成之后，你可以使用下面的命令来检验是否安装成功

`$ gitbook -V`

更多详情请参照 [gitbook 安装文档](https://github.com/GitbookIO/gitbook/blob/master/docs/setup.md) 来安装 gitbook

### 3. 安装 Gitlab Runner

下载二进制包

`sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64`

添加执行权限

`sudo chmod +x /usr/local/bin/gitlab-runner`

(可选)如果使用Docker，安装Docker

`curl -sSL https://get.docker.com/ | sh`

创建 GitLab CI 用户

`sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash`

以Service方式安装

```bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner start
```

### 4. 注册Runner

- [Runner安装](https://docs.gitlab.com/runner/install/linux-manually.html)    
- [Runner注册](https://docs.gitlab.com/runner/register/index.html)

运行以下命令

`sudo gitlab-runner register`

输入GitLab 实例 URL `Please enter the gitlab-ci coordinator URL`

输入Gitlab注册的token (Gitlab admin权限才能看见)

`Please enter the gitlab-ci token for this runner
    xxx`

输入Runner描述，后面可在Gitlab UI上更新

`Please enter the gitlab-ci description for this runner`

输入Runner Tag，后面可在Gitlab UI上更新

`Please enter the gitlab-ci tags for this runner (comma separated):`

选择Runner executor

 `Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell:
    shell`

## gitbook 配置

### 1. 目录结构

```text
        .
        ├── book.json
        ├── README.md
        ├── SUMMARY.md
        ├── chapter-1/
        |   ├── README.md
        |   └── something.md
        └── chapter-2/
            ├── README.md
            └── something.md
```

- README.md
  gitbook第一页内容是从文件 README.md 中提取的。如果这个文件名没有出现在 SUMMARY 中，那么它会被添加为章节的第一个条目

- book.json  
  该文件主要用来存放配置信息

- .bookignore
  将读取.gitignore，.bookignore以及.ignore文件以获得文件和文件夹跳过列表

- Glossary.md
  允许指定要显示为注释的术语及其各自的定义。根据这些条款，GitBook将自动构建一个索引并突出显示这些术语

- SUMMARY.md
  用于存放GitBook的文件目录信息，左侧的目录就是根据这个文件来生成的，默认对应的文件是 SUMMARY.md，可以在 book.json 重新定义该文件的对应值。它通过Markdown中的列表语法来表示文件的父子关系

  **注意** 不被SUMMARY.md包含的文件不会被gitbook处理

  **SUMMARY.md示例：**

    ```text
    # Summary

    * [Introduction](README.md)
    * [Part I](part1/README.md)
        * [Writing is nice](part1/writing.md)
        * [gitbook is nice](part1/gitbook.md)
    * [Part II](part2/README.md)
        * [We love feedback](part2/feedback_please.md)
        * [Better tools for authors](part2/better_tools.md)
    ```

    通过使用 标题 或者 水平分割线 将 gitbook 分为几个不同的部分，如下所示：

    ```text
    # Summary

    ### Part I

    * [Introduction](README.md)
    * [Writing is nice](part1/writing.md)
    * [gitbook is nice](part1/gitbook.md)

    ### Part II

    * [We love feedback](part2/feedback_please.md)
    * [Better tools for authors](part2/better_tools.md)

    ---

    * [Last part without title](part3/title.md)
    ```

    目录中的章节可以使用锚点指向文件的特定部分

    ```text
    # Summary

    ### Part I

    * [Part I](part1/README.md)
        * [Writing is nice](part1/README.md#writing)
        * [gitbook is nice](part1/README.md#gitbook)
    * [Part II](part2/README.md)
        * [We love feedback](part2/README.md#feedback)
        * [Better tools for authors](part2/README.md#tools)
    ```

### 2. 命令行

1. gitbook init

    gitbook项目初始化,会自动生成两个必要的文件 README.md 和 SUMMARY.md

2. gitbook build [path]

    构建gitbook项目生成静态网页，会生成一个 _book 文件夹（包含了 .md 对应的.html文件）

3. gitbook serve

   该命令实际上会首先调用 gitbook build 编译 .md，完成以后会打开一个web服务器，监听在本地的4000端口。

   生产的静态文件可单独放到tomcat或者nginx供静态访问

    ``` text
    ./
    ├── _book
    │   ├── gitbook
    │   │   ├── fonts
    │   │   ├── gitbook.js
    │   │   ├── gitbook-plugin-fontsettings
    │   │   ├── gitbook-plugin-highlight
    │   │   ├── gitbook-plugin-livereload
    │   │   ├── gitbook-plugin-lunr
    │   │   ├── gitbook-plugin-search
    │   │   ├── gitbook-plugin-sharing
    │   │   ├── images
    │   ├── index.html
    │   └── search_index.json
    ├── README.md
    └── SUMMARY.md
    ```

4. gitbook update #更新gitbook到最新版本

5. gitbook install    #安装依赖

6. gitbook builid --debug    #输出错误信息

7. gitbook build --log=debug  #指定log级别

### 3. 插件

gitbook 提供了丰富插件，默认带有 5 个插件，highlight、search、sharing、font-settings、livereload，如果要去除自带的插件， 可以在插件名称前面加 -，比如：
  
```bash
        "plugins": [
            "-search"
        ]
```

插件使用参考

- <https://gitbook.zhangjikai.com/plugins.html>

## gitlab 与gitbook集成 

**.gitlab-ci.yml 示例：**

``` yaml
# requiring the environment of NodeJS 10
image: node:10

# add 'node_modules' to cache for speeding up builds
cache:
  paths:
    - node_modules/ # Node modules and dependencies

before_script:
  - npm install gitbook-cli -g # install gitbook
  - gitbook fetch 3.2.3 # fetch final stable version
  - gitbook install # add any requested plugins in book.json

test:
  stage: test
  script:
    - gitbook build . public # build to public path
  only:
    - branches # this job will affect every branch except 'master'
  except:
    - master
    
# the 'pages' job will deploy and build your site to the 'public' path
pages:
  stage: deploy
  script:
    - gitbook build . public # build to public path
  artifacts:
    paths:
      - public
    expire_in: 1 week
  only:
    - master # this job will affect only the 'master' branch

```

## 参考

- <http://www.chengweiyang.cn/gitbook/index.html>