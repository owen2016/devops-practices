# 批量修改docker tag的脚本

import docker
import os


def write_log(image_info, changed):
    if changed:
        with open('changed.log', 'a+') as file:
            file.writelines(image_info)
    else:
        with open('not_changed.log', 'a+') as file:
            file.writelines(image_info)


def add_tag(image):
    repository = "registry.cn-shanghai.aliyuncs.com/openstack_kolla/openstack_kolla/"
    tags = [tag for tag in image.tags if tag.startswith('kolla')]
    if tags:
        old_tag = tags[0]
        repository += old_tag.split('/')[1].split(':')[0]
        tag_name = old_tag.split('/')[1].split(':')[1]
        image.tag(repository, tag_name)
        write_log(old_tag, changed=True)
        print('successfully taged: %s , %s' % (repository, tag_name))
    write_log(image.id, changed=False)

client = docker.from_env()
images = client.images.list()

for image in images:
    add_tag(image)