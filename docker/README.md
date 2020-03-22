# docker file

## Dockerfile-node
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