# Jenkins 参数传递

配置参数：
    General－＞This project is parameterized

使用：
    1. Jenkinsfile执行中使用（https://blog.johnwu.cc/article/jenkins-pipeline-job-boolean-parameter.html）
        jenkinsfile中
            echo "BRANCH=${BRANCH}"

        注意：必须双引号

    2. jenkins配置页面中参数替换（https://blog.csdn.net/Ywylalala/article/details/83929856）
        结论：
            按照正常方式配置和使用参数

            去掉勾选：最下面的Pipeline里的 Lightweight checkout，因为勾选了之后它不会解析参数化构建的参数




１．我们进入我们目标Jenkins任务，选择【参数化构建过程】-》【添加参数】-》【Git Parameter Plug-In】
    ＊原来添加branch的地方，去掉branch参数＊

    １．１）添加Git Parameter
        Name: Tag
        Parameter Type: Tag
        Default Value：　origin/master

    １．２）删除branch配置参数

    １．３）修改Source Code Management
        Branches to build修改为
            ${Tag}或$Tag

    １．４）检查代码是否是正确的tag部分
        进入代码存放地方，用git命令查看
            
            jenkins代码存储的工作空间路径(https://blog.csdn.net/ZZY1078689276/article/details/77485615)
            【系统管理】－＞【系统设置】－＞默认： /var/lib/jenkins

              /var/lib/jenkins/workspace

２．修改dev-build-vwork-backend-common-dependencies
  执行脚本gen-stub为：

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
```shell
#! /bin/bash
set -e

WORKSPACE=${WORKSPACE:-$(pwd)}

GIT_DOMAIN=${GIT_DOMAIN:-"ssh://git@gitlab.vivo.com:2289"}
GIT_GROUP=${GIT_GROUP:-"vwork"}

Tag=${Tag:-'origin/master'}

git checkout ${Tag}

MODULES="vwork-customer vwork-account vwork-warehouse vwork-product vwork-common vwork-sales vwork-job vwork-thirdparty vwork-hrms"

for module in $MODULES; do
  cd ${WORKSPACE}
  if [ ! -e ${WORKSPACE}/$module ]; then
    git clone $GIT_DOMAIN/$GIT_GROUP/$module.git
    cd ${WORKSPACE}/$module
    git checkout ${Tag}
  else
    cd ${WORKSPACE}/$module
    git checkout ${Tag}
  fi
done```
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
３．对于默认tag => origin/master
  正常

４．配置jenkins（添加job 之间实现带参数触发：https://blog.csdn.net/workdsz/article/details/77935374）
  Build　－＞　Trigger/call builds on other projects

  add "Predefined parameters"
    Tag=${Tag}

vwork-frontend:
    1)删除Branch参数，添加Git parameter参数
        Name: Tag
        Parameter Type: Tag
        Default Value: origin/master  ***如果是prod环境，值为：origin/master; 如果是其他环境，值为origin/develop***

    2)修改Source Code Management－＞Branches to build
        Branch Specifier (blank for 'any')　＝＞　${Tag}

vwork-backend-common-dependencies:
    1)第一步同（完全）vwork-frontend

    2)修改Build－＞Execute shell
        ./gen-stub　（最好加一个文件，然后修改shell运行该文件）

        文件内容如下：
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#! /bin/bash
set -e

WORKSPACE=${WORKSPACE:-$(pwd)}

GIT_DOMAIN=${GIT_DOMAIN:-"ssh://git@gitlab.vivo.com:2289"}
GIT_GROUP=${GIT_GROUP:-"vwork"}

Tag=${Tag:-'origin/master'}

git checkout ${Tag}

MODULES="vwork-customer vwork-account vwork-warehouse vwork-product vwork-common vwork-sales vwork-job vwork-thirdparty vwork-hrms"

for module in $MODULES; do
  cd ${WORKSPACE}
  if [ ! -e ${WORKSPACE}/$module ]; then
    git clone $GIT_DOMAIN/$GIT_GROUP/$module.git
    cd ${WORKSPACE}/$module
    git checkout ${Tag}
  else
    cd ${WORKSPACE}/$module
    git checkout ${Tag}
  fi
done
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


vwork-common-service: 相关service一样
    1)第一步同（完全）vwork-frontend

    2)修改Build－＞Trigger/call builds on other projects

        add "Predefined parameters"
        Tag=${Tag}

vwork-backend:
    1)第一步同（完全）vwork-frontend

    2)修改Build－＞Execute shell
        ./buildImage.sh改为新增文件./buildImageByTag.sh

        文件内容修改：
            1)修改./gen-stub为vwork-backend-common-dependencies中提到的第二步


        文件如下：
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#!/bin/bash

set -e

PROJECT_NAME="vwork"
SERVICES="${SERVICES:-"common customer account warehouse product sales job thirdparty hrms"}"

HARBOR="${HARBOR:-"docker-vwork.vivo.xyz"}"
BUILDER_IMAGE="${BUILDER_IMAGE:-"${HARBOR}/base/builder"}"
ENV="${ENV:-dev}"
ENV_VERSION="${ENV}-$(date "+%Y%m%d%H%M")"
MAVEN_DIR="${MAVEN_DIR:-"/data01/.m2"}"
WORKSPACES="$(pwd)"

./gen-stub-by-tag

vwork-init

docker run --rm -v ${MAVEN_DIR}/${ENV}:/root/.m2 -v ${WORKSPACES}:/root ${BUILDER_IMAGE} mvn clean install -Dmaven.test.skip=true

for service in ${SERVICES[@]}; do
    moduleName="${PROJECT_NAME}-$service"

    if [ $service == 'common' ]; then
        cp ${moduleName}/common-rest/target/${moduleName}.jar docker/${moduleName}
    else
        cp ${moduleName}/target/${moduleName}.jar docker/${moduleName}
    fi

    IMAGE_NAME="${HARBOR}/vwork-backend/${moduleName}"
    IMAGE="${IMAGE_NAME}:${ENV_VERSION}"

    echo "=============================================="
    echo "build image: ${IMAGE}, ${IMAGE_NAME}:${ENV}"
    echo "=============================================="

    docker build -t ${IMAGE} -t ${IMAGE_NAME}:${ENV} --build-arg env=${ENV} -f docker/${moduleName}/Dockerfile docker/${moduleName}
    docker push ${IMAGE}
    docker push ${IMAGE_NAME}:${ENV}

    export IMAGE_TAG="${ENV_VERSION}"
    latestServiceImageTag set ${moduleName}
done
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
