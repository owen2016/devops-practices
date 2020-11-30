# docker-pull/push

`chmod +x ./push.sh ./pushall.sh ./pull.sh`

``` shell


# 上传指定镜像(可上传多个，中间用空格隔开)
./push.sh ImageName[:TagName] [ImageName[:TagName] ···]
# 例如：./push.sh busybox:latest ubutnu:14.04

# 上传所有镜像
./pushall.sh

# 下载指定镜像(可上传多个，中间用空格隔开)
./pull.sh ImageName[:TagName] [ImageName[:TagName] ···]
# 例如：./pull.sh busybox:latest ubutnu:14.04

```