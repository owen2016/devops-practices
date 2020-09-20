# 常用Dockerfile

## jenkins


```
docker build -f Dockerfile-jenkins  -t owen2016/jenkins:1.0 . 

## DooD（Docker-outside-of-Docker）
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(which docker):/usr/bin/docker \
  -p 8080:8080 \
  owen2016/jenkins

docker run -u root -itd --name  my-jenkins -p 8080:8080 -p 50000:50000 --restart=always \
   -v /var/jenkins_home:/var/jenkins_home \
   -v $(which docker):/usr/bin/docker \
   -v $(which git):/usr/bin/git \
   -v /etc/localtime:/etc/localtime \
   -v /etc/timezone:/etc/timezone \
   -v /var/run/docker.sock:/var/run/docker.sock  owen2016/jenkins:1.0

```


## node
```
#!/bin/bash -l
set -ex 

docker build -t registry.cn-hangzhou.aliyuncs.com/123/minerdash:${BUILD_NUMBER} .
# docker image tag registry.cn-hangzhou.aliyuncs.com/123/minerdash:${BUILD_NUMBER} registry.cn-hangzhou.aliyuncs.com/123/minerdash:latest

docker push registry.cn-hangzhou.aliyuncs.com/123/minerdash:${BUILD_NUMBER}

set -ex
docker pull registry.cn-hangzhou.aliyuncs.com/123/minerdash:${BUILD_NUMBER}
docker rm -f minerdash || true
docker run -d --name minerdash --network host registry.cn-hangzhou.aliyuncs.com/123/minerdash:${BUILD_NUMBER}
```