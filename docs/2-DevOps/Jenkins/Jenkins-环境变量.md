# 环境变量

## 内置变量

    BRANCH_NAME
    对于多分支项目，这将被设置为正在构建的分支的名称，例如，如果您希望从master部署到生产环境而不是从feature分支部署；如果对应某种更改请求，则该名称通常是任意的（请参阅下面的CHANGE_ID和CHANGE_TARGET）；

    CHANGE_ID
    对于与某种更改请求相对应的多分支项目，这将被设置为更改ID，例如拉取请求编号（如果支持）;其他未设置；

    CHANGE_URL
    对于与某种更改请求相对应的多分支项目，这将被设置为更改URL(如果支持)；其他未设置；

    CHANGE_TITLE
    对于与某种更改请求相对应的多分支项目，这将被设置为更改的标题（如果支持）;其他未设置；

    CHANGE_AUTHOR
    对于与某种更改请求相对应的多分支项目，这将被设置为建议更改的作者的用户名（如果支持）;其他未设置；

    CHANGE_AUTHOR_DISPLAY_NAME
    对于与某种更改请求相对应的多分支项目，这将被设置为建议更改的作者的人名（如果支持）;其他未设置；

    CHANGE_AUTHOR_EMAIL
    对于与某种更改请求相对应的多分支项目，这将被设置为建议更改的作者的Email地址（如果支持）;其他未设置；

    CHANGE_TARGET
    对于与某种更改请求相对应的多分支项目，这将被设置为合并到的目标或者基础分支（如果支持）;其他未设置；

    BUILD_NUMBER 当前构建的编号，例如“4674”等

    BUILD_ID
    当前构建的版本ID，与构建的BUILD_NUMBER相同

    BUILD_DISPLAY_NAME
    当前版本的显示名称，默认为“# 4674”，即BUILD_NUMBER。

    JOB_NAME
    即此版本的项目名称，例如“foo”或“foo / bar”。

    image.gif
    JOB_BASE_NAME
    此构建的项目的短名称剥离文件夹路径，例如“bar / foo”的“foo”。

    BUILD_TAG
    “jenkins -  {BUILD_NUMBER}”的字符串。 JOB_NAME中的所有正斜杠（/）都用破折号（ - ）替换。方便地放入资源文件，jar文件等，以便于识别。

    EXECUTOR_NUMBER
    唯一编号，用于标识执行此构建的当前执行程序（在同一台计算机的执行程序中）。这是您在“构建执行程序状态”中看到的数字，但数字从0开始，而不是从1开始。

    NODE_NAME
    如果构建在代理上，则代理的名称; 如果在主版本上运行，则为“MASTER”；

    NODE_LABELS
    节点分配的空白分隔的标签列表。

    WORKSPACE
    作为工作空间分配给构建的目录的绝对路径。

    JENKINS_HOME
    Jenkins用于存储数据的主节点上分配的目录的绝对路径。

    JENKINS_URL
    Jenkins的完整URL，如http：// server：port / jenkins /（注意：仅在系统配置中设置Jenkins URL时可用）

    BUILD_URL
    此版本的完整URL，例如http：// server：port / jenkins / job / foo / 15 /（必须设置Jenkins URL）

    JOB_URL
    该作业的完整URL，例如http：// server：port / jenkins / job / foo /（必须设置Jenkins URL）

    GIT_COMMIT
    The commit hash being checked out.

    GIT_PREVIOUS_COMMIT
    The hash of the commit last built on this branch, if any.

    GIT_PREVIOUS_SUCCESSFUL_COMMIT
    The hash of the commit last successfully built on this branch, if any.

    GIT_BRANCH
    远程分支名称，如果有的话。

    GIT_LOCAL_BRANCH
    本地分支名称，如果有的话。

    GIT_URL
    远程git仓库的URL。如果有多个，将会是GIT_URL_1，GIT_URL_2等。

    GIT_COMMITTER_NAME
    配置的Git提交者名称（如果有的话）。

    GIT_AUTHOR_NAME
    配置的Git作者姓名（如果有的话）。

    GIT_COMMITTER_EMAIL
    配置的Git提交者电子邮件（如果有的话）。

    GIT_AUTHOR_EMAIL
    已配置的Git作者电子邮件（如果有）。

    SVN_REVISION
    当前工作区的Subversion版本号，例如“12345”

    SVN_URL
    当前工作区的Subversion版本号，例如“12345”

## 自定义变量

    - 全局  -所有job都可以使用
    - Node -运行在该slave上的job 可以使用
    - job  -一般作为参数传入job,用于参数化pipeline
