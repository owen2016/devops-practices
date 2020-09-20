# delete-or-list-docker-registry-images
If you are running a private v2 docker registry, and you are storing your data on disk, running this script will let you delete or list images.

```
[jiankunking@test]# python registry.py --help
usage: registry.py [-h] [-l USER:PASSWORD] -r URL [-d]
                                       [-n [N]] [--dry-run] [-i IMAGE:[TAG]
                                       [IMAGE:[TAG] ...]]
                                       [--keep-tags KEEP_TAGS [KEEP_TAGS ...]]
                                       [--tags-like TAGS_LIKE [TAGS_LIKE ...]]
                                       [--keep-tags-like KEEP_TAGS_LIKE [KEEP_TAGS_LIKE ...]]
                                       [--no-validate-ssl] [--delete-all]
                                       [--layers]

List or delete images from Docker registry

optional arguments:
  -h, --help            show this help message and exit
  -l USER:PASSWORD, --login USER:PASSWORD
                        Login and password to access to docker registry
  -r URL, --host URL    Hostname for registry server, e.g.
                        https://example.com:5000
  -d, --delete          If specified, delete all but last 10 tags of all
                        images
  -n [N], --num [N]     Set the number of tags to keep(10 if not set)
  --dry-run             If used in combination with --delete,then images will
                        not be deleted
  -i IMAGE:[TAG] [IMAGE:[TAG] ...], --image IMAGE:[TAG] [IMAGE:[TAG] ...]
                        Specify images and tags to list/delete
  --keep-tags KEEP_TAGS [KEEP_TAGS ...]
                        List of tags that will be omitted from deletion if
                        used in combination with --delete or --delete-all
  --tags-like TAGS_LIKE [TAGS_LIKE ...]
                        List of tags (regexp check) that will be handled
  --keep-tags-like KEEP_TAGS_LIKE [KEEP_TAGS_LIKE ...]
                        List of tags (regexp check) that will be omitted from
                        deletion if used in combination with --delete or
                        --delete-all
  --no-validate-ssl     Disable ssl validation
  --delete-all          Will delete all tags. Be careful with this!
  --layers              Show layers digests for all images and all tags

IMPORTANT: after removing the tags, run the garbage collector
           on your registry host:
   docker-compose -f [path_to_your_docker_compose_file] run \
       registry bin/registry garbage-collect \
       /etc/docker/registry/config.yml
or if you are not using docker-compose:
   docker run registry:2 bin/registry garbage-collect \
       /etc/docker/registry/config.yml
for more detail on garbage collection read here:
   https://docs.docker.com/registry/garbage-collection/
```

# example

```
# http://10.138.11.111:5000 registry 中只保留最新的5个tag，其余的删除
python registry.py --num=5  --host=http://10.138.11.111:5000  --delete
```

# 常见问题
## 删除tag失败，返回405
修改registry容器内的/etc/docker/registry/config.yml

添加storage:delete:enabled: true

示例如下：
```
version: 0.1
log:
  fields:
    service: registry
storage:
    delete:
        enabled: true
    cache:
        blobdescriptor: inmemory
    filesystem:
        rootdirectory: /var/lib/registry
http:
    addr: :5000
    headers:
        X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
```
## registry garbage-collect
```
# 进入registry容器
registry garbage-collect /etc/docker/registry/config.yml
```
