#!/bin/bash
#cnetos7,docker-ce v18.09.9,registry v2.6.2
#Docker registry 私有仓库镜像查询、删除、上传、下载
#Author  https://www.cnblogs.com/caoweixiong

# >>>>>>>>>>>>>>>>>>>>使用说明<<<<<<<<<<<<<<<<<<<<<<<
#sh image_registry.sh  -h   #查看帮助
#HUB=10.0.29.104:5000 改为自己的地址


#root
[[ $UID -ne 0 ]] && { echo "Run in root user !";exit; }
#need jq ,get json data
[[ -f /usr/bin/jq ]] || { echo 'install jq';yum install -y jq &>/dev/null; }

#参数 variable
#registry容器名称,默认registry
RN=${RN:-registry}
#访问网址,默认localhost:5000
HUB=${HUB:-localhost:5000}
HUB=10.0.29.104:5000

# 检测 check
function Check_hub() {
  [[ `curl -s $HUB/v2/_catalog` == "Failed connect" ]] && { echo -e "\033[31m$HUB 访问失败\033[0m";exit;  }
}

# 删除images
function Delete_img() {
  for n in $IMGS;
  do
    IMG=${n%%:*}
    TAG=${n##*:}
    echo "IMG=${IMG}"
    echo "TAG=${TAG}"
    i=1
    [[ "$IMG" == "$TAG" ]] && { TAG=latest; n="$n:latest"; }
    Digest=`curl --header "Accept: application/vnd.docker.distribution.manifest.v2+json" -Is ${HUB}/v2/${IMG}/manifests/${TAG} |awk '/Digest/ {print $NF}'`
    echo "Digest=${Digest}"
    [[ -z "$Digest" ]] && { echo -e "\033[31m$IMG:$TAG  镜像不存在\033[0m";} || {
      URL="${HUB}/v2/${IMG}/manifests/${Digest}"
      echo "URL=${URL}"
      Rs=$(curl -Is -X DELETE ${URL%?}|awk '/HTTP/ {print $2}')
      echo "Rs=${Rs}"
      [[ $Rs -eq 202 ]] && { let i++;echo "$n  删除成功"; } || { echo -e "\033[31m$n  删除失败\033[0m"; }
    }
  done
  #registry垃圾回收 RN=registry
  [[ "$i" -gt 1 ]] && {
    echo "Clean...";
    docker exec ${RN} /bin/registry garbage-collect /etc/docker/registry/config.yml &>/dev/null;
    docker restart ${RN} &>/dev/null;
  }
}

# 删除镜像所在目录(清除所有 -dd .* )
# 简单高效,删库跑路，必备技能
function Delete_img_a() {
  [[ -f /usr/bin/docker ]] || echo 'No docker !'
  [[ -z $(docker ps |awk '/'$RN'/ {print $NF}') ]] && { echo "$RN容器不存在!";exit; }
  for n in $IMGS;
  do
    IMG="${n%%:*}"
    docker exec $RN rm -rf /var/lib/registry/docker/registry/v2/repositories/$IMG
    echo "$IMG 删除成功"
  done
  echo '清理 Clean ...'
  docker exec $RN bin/registry garbage-collect /etc/docker/registry/config.yml &>/dev/null
  docker restart $RN &>/dev/null
}

# 上传 push
function Push() {
  for IMG in $IMGS;
  do
    echo -e "\033[33m docker push $IMG to $HUB \033[0m"
    docker tag $IMG $HUB/$IMG
    docker push $HUB/$IMG
    docker rmi $HUB/$IMG &>/dev/null
  done
}

# 下载 pull
function Pull() {
  for IMG in $IMGS;
  do
    echo -e "\033[33m dokcer pull $IMG from $HUB \033[0m"
    docker pull $HUB/$IMG
    docker tag $HUB/$IMG $IMG
    docker rmi $HUB/$IMG &>/dev/null
  done
}

# 查询images
function Select_img() {
  IMG=$(curl -s $HUB/v2/_catalog |jq .repositories |awk -F'"' '{for(i=1;i<=NF;i+=2)$i=""}{print $0}')
  [[ $IMG = "" ]] && { echo -e "\033[31m$HUB 没有docker镜像\033[0m";exit; }
  #echo "$HUB Docker镜像："
  for n in $IMG;
  do
    echo "*****************【$n】******************"
    TAG=$(curl -s http://$HUB/v2/$n/tags/list |jq .tags |awk -F'"' '{for(i=1;i<=NF;i+=2)$i=""}{print $0}')
    for t in $TAG;
    do
      echo "$n:$t";
    done
  done
}

case "$1" in
  "-h")
  echo  
  echo "#默认查询images"
  echo "sh $0 -h #帮助 -d #删除 -dd #清理空间"
  echo "    -pull img1 img2 #下载 -push #上传"
  echo 
  echo "#示例：删除 nginx:1.1 nginx:1.2 (镜像名:版本)"
  echo "sh $0 -d nginx:1.1 nginx:1.2 "
  echo "sh $0 -dd nginx #删除nginx所有版本"
  echo 
  echo "#定义仓库url地址hub.test.com:5000(默认 localhost:5000)"
  echo "env HUB=hub.test.com:5000 /bin/sh $0 -d nginx:1.1 "
  echo  
;;
  "-d")
  Check_hub
  IMGS=${*/-dd/}
  echo "IMGS=${IMGS}"
  IMGS=${IMGS/-d/}
  echo "IMGS=${IMGS}"
  Delete_img
;;
  "-dd")
  Check_hub
  IMGS=${*/-dd/}
  IMGS=${IMGS/-d/}
  Delete_img_a
;;
  "-pull")
  IMGS=${*/-pull/}
  Pull
;;
  "-push")
  IMGS=${*/-push/}
  Push
;;
  *)
  Check_hub
  Select_img
;;
esac