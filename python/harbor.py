#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 脚本的整执行流程：
# 	1. 先实现一个request来完成harbor的登录，获取session
# 	2. 获取所有的project
# 	3. 循环所有的project，获取所有的repositories
# 	4. 获取repositories的所有tag
# 	5. 根据repositories和tag拼接完整的镜像名称
# 	6. 连接两边的harbor，通过docker pull的方式从原harbor中拉取镜像，再通过docker push的方式将镜像推送到新harbor当中，然后删除本地镜像。
# 	7. 在上面的过程中，还做了个事情，每个镜像推送之后，都会将其镜像名称作为key，将其状态作为value保存到redis中。以备事后处理推送失败的镜像

import requests
import subprocess
import json
import redis
import sys


class RequestClient(object):

    def __init__(self, login_url, username, password):
        self.username = username
        self.password = password
        self.login_url = login_url
        self.session = requests.Session()
        self.login()

    def login(self):
        self.session.post(self.login_url, params={"principal": self.username, "password": self.password})


class HarborRepos(object):

    def __init__(self, harbor_domain, harbor_new_domain, password, new_password, schema="https", new_schema="https",
                 username="admin", new_username="admin"):
        self.schema = schema
        self.harbor_domain = harbor_domain
        self.harbor_new_domain = harbor_new_domain
        self.harbor_url = self.schema + "://" + self.harbor_domain
        self.login_url = self.harbor_url + "/login"
        self.api_url = self.harbor_url + "/api"
        self.pro_url = self.api_url + "/projects"
        self.repos_url = self.api_url + "/repositories"
        self.username = username
        self.password = password
        self.client = RequestClient(self.login_url, self.username, self.password)

        self.new_schema = new_schema
        self.harbor_new_url = self.new_schema + "://" + self.harbor_new_domain
        self.login_new_url = self.harbor_new_url + "/c/login"
        self.api_new_url = self.harbor_new_url + "/api"
        self.pro_new_url = self.api_new_url + "/projects"
        self.new_username = new_username
        self.new_password = new_password
        self.new_client = RequestClient(self.login_new_url, self.new_username, self.new_password)

    def __fetch_pros_obj(self):
        # TODO
        self.pros_obj = self.client.session.get(self.pro_url).json()

        return self.pros_obj

    def fetch_pros_id(self):
        self.pros_id = []
        # TODO
        pro_res = self.__fetch_pros_obj()

        for i in pro_res:
            self.pros_id.append(i['project_id'])

        return self.pros_id

    def fetch_pro_name(self, pro_id):
        # TODO
        pro_res = self.__fetch_pros_obj()

        for i in pro_res:
            if i["project_id"] == pro_id:
                self.pro_name = i["name"]

        return self.pro_name

    # def judge_pros(self,pro_name):
    #    res = self.new_client.session.head(self.pro_new_url,params={"project_name": pro_name})
    #    print(res.status_code)
    #    if res.status_code == 404:
    #        return False
    #    else:
    #        return True

    def create_pros(self, pro_name):
        '''
        {
          "project_name": "string",
          "public": 1
        }

        '''
        pro_res = self.__fetch_pros_obj()
        pro_obj = {}
        pro_obj["metadata"]={}
        public = "false"
        for i in pro_res:
            if i["name"] == pro_name:
                pro_obj["project_name"] = pro_name
                if i["public"]:
                    public = "true"
                pro_obj["metadata"]["public"] = public
                # pro_obj["metadata"]["enable_content_trust"] = i["enable_content_trust"]
                # pro_obj["metadata"]["prevent_vul"] = i["prevent_vulnerable_images_from_running"]
                # pro_obj["metadata"]["severity"] = i["prevent_vulnerable_images_from_running_severity"]
                # pro_obj["metadata"]["auto_scan"] = i["automatically_scan_images_on_push"]
        headers = {"content-type": "application/json"}
        print(pro_obj)
        res = self.new_client.session.post(self.pro_new_url, headers=headers, data=json.dumps(pro_obj))
        if res.status_code == 409:
            print("\033[32m 项目 %s 已经存在!\033[0m" % pro_name)
            return True
        elif res.status_code == 201:
            # print(res.status_code)
            print("\033[33m 创建项目%s成功!\033[0m" % pro_name)
            return True
        else:
            print(res.status_code)
            print("\033[35m 创建项目%s失败!\033[0m" % pro_name)
            return False

    def fetch_repos_name(self, pro_id):
        self.repos_name = []

        repos_res = self.client.session.get(self.repos_url, params={"project_id": pro_id})
        # TODO
        for repo in repos_res.json():
            self.repos_name.append(repo['name'])
        return self.repos_name

    def fetch_repos(self, repo_name):
        self.repos = {}

        tag_url = self.repos_url + "/" + repo_name + "/tags"
        # TODO
        for tag in self.client.session.get(tag_url).json():
            full_repo_name = self.harbor_domain + "/" + repo_name + ":" + tag["name"]
            full_new_repo_name = self.harbor_new_domain + "/" + repo_name + ":" + tag["name"]
            self.repos[full_repo_name] = full_new_repo_name

        return self.repos

    def migrate_repos(self, full_repo_name, full_new_repo_name, redis_conn):
        # repo_cmd_dict = {}
        if redis_conn.exists(full_repo_name) and redis_conn.get(full_repo_name) == "1":
            print("\033[32m镜像 %s 已经存在!\033[0m" % full_repo_name)
            return
        else:
            cmd_list = []
            pull_old_repo = "docker pull " + full_repo_name
            tag_repo = "docker tag " + full_repo_name + " " + full_new_repo_name
            push_new_repo = "docker push " + full_new_repo_name
            del_old_repo = "docker rmi -f " + full_repo_name
            del_new_repo = "docker rmi -f " + full_new_repo_name
            cmd_list.append(pull_old_repo)
            cmd_list.append(tag_repo)
            cmd_list.append(push_new_repo)
            cmd_list.append(del_old_repo)
            cmd_list.append(del_new_repo)
            # repo_cmd_dict[full_repo_name] = cmd_list
            sum = 0
            for cmd in cmd_list:
                print("\033[34m Current command: %s\033[0m" % cmd)
                ret = subprocess.call(cmd, shell=True)
                sum += ret
            if sum == 0:
                print("\033[32m migrate %s success!\033[0m" % full_repo_name)
                redis_conn.set(full_repo_name, 1)
            else:
                print("\033[33m migrate %s faild!\033[0m" % full_repo_name)
                redis_conn.set(full_repo_name, 0)
            return


if __name__ == "__main__":
    harbor_domain = "hub.test.com"
    harbor_new_domain = "hub-new.test.com"
    re_pass = "xxxxxxx"
    re_new_pass = "xxxxxxx"
    pool = redis.ConnectionPool(host='localhost', port=6379,
                                decode_responses=True)  # host是redis主机，需要redis服务端和客户端都起着 redis默认端口是6379
    redis_conn = redis.Redis(connection_pool=pool)

    res = HarborRepos(harbor_domain, harbor_new_domain, re_pass, re_new_pass)
    # pros_id = res.fetch_pro_id()

    for pro_id in res.fetch_pros_id():
        #pro_id = 13
        pro_name = res.fetch_pro_name(pro_id)
        # print(pro_name)
        # ret = res.judge_pros(pro_name)
        # print(ret)
        res.create_pros(pro_name)
    #sys.exit() 
    for pro_id in res.fetch_pros_id():
        repos_name = res.fetch_repos_name(pro_id=pro_id)
        for repo_name in repos_name:
            repos = res.fetch_repos(repo_name=repo_name)
            for full_repo_name, full_new_repo_name in repos.items():
                res.migrate_repos(full_repo_name, full_new_repo_name, redis_conn)

