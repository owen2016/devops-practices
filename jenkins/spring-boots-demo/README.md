## 使用指南:  
1. 项目使用maven进行jar包和docker image的构建

    |maven 生命阶段|docker 操作|
    |:---|:---|
    |clean|docker images remove(TODO)|
    |package|docker images build|
    |deploy|docker images tag add push|

2. 防止开发人员因误操作造成docker images错误push的方法  
    2.1 不在pom.xml等在SCM中的文件中保存用户登录信息, 只在build服务器上使用docker login登录harbor仓库,并保存其登录凭证.  
    2.2 在~/.m2/settings.xml中保存用户登录信息, 在开发机和build服务器上分别保存不同的用户登录信息, 开发人员可通过此方法将包含微服务的docker image推送到开发环境的harbor仓库.

## 问题列表:
1. Harbor未配置HTTPS 造成的Docker Login失败,错误信息如下:  
    ```
    INFO[0008] Error logging in to v2 endpoint, trying next endpoint: Get https://192.168.4.239/v2/: dial tcp 192.168.4.239:443: connect: connection refused  
    INFO[0008] Error logging in to v1 endpoint, trying next endpoint: Get https://192.168.4.239/v1/users/: dial tcp 192.168.4.239:443: connect: connection refused  
    Get https://192.168.4.239/v1/users/: dial tcp 192.168.4.239:443: connect: connection refused
    ``` 
    解决方案:  
    ```
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
      "registry-mirrors": ["https://l5zaq95y.mirror.aliyuncs.com"],
      "insecure-registries":["192.168.4.239"]
    }
    EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```
2. 找不到host harbor.augcloud.com 及解决方案
    ```
    sudo cat >> /etc/hosts <<-'EOF'
    192.168.4.239 harbor.augcloud.com
    EOF
    ```
3. Ansible的shell module 和dokcer_login都可以进行docker的login,但是docker_login 在~/.docker/config.json中生产的证书如下
    ```
    "auths": {
              "192.168.4.239": {
                   "auth": "U2ltb24uRmVuZzphYmMxMjNf",
                   "email": null
              }
         },
    ```
    在pull的时候无法使用, shello module 生成的证书是
    ```
    "auths": {
                    "192.168.4.239": {}
            },
    ```
4. Ansible 连接失败,错误信息如下
    ```
    fatal: [server1]: FAILED! => {"msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."}
    ```
    解决方案:
    ```
    vi /etc/ansible/ansible.cfg
    :/host_key_checking
    # uncomment this to disable SSH key host checking
    #host_key_checking = False
    修改后：
    # uncomment this to disable SSH key host checking
    host_key_checking = False
    ```
5. Ansible 执行playbook 出错
    ```
    TASK [Log into private registry and force re-authorization] *************************************************************************************
    fatal: [server1]: FAILED! => {"changed": true, "cmd": "docker login -u 'Simon.Feng' 192.168.4.239", "delta": "0:00:00.346375", "end": "2019-10-25 18:58:51.236955", "msg": "non-zero return code", "rc": 1, "start": "2019-10-25 18:58:50.890580", "stdout": "Password: \r\nError saving credentials: error storing credentials - err: exit status 1, out: `Cannot autolaunch D-Bus without X11 $DISPLAY`", "stdout_lines": ["Password: ", "Error saving credentials: error storing credentials - err: exit status 1, out: `Cannot autolaunch D-Bus without X11 $DISPLAY`"]} to retry, use: --limit @/jenkins-agents/agent-2/workspace/tmp/deploy.retry

    PLAY RECAP **************************************************************************************************************************************
    server1                    : ok=1    changed=0    unreachable=0    failed=1
    ````
    解决方案:

    在被控主机上卸载docker-compose
    ```
    sudo apt-get autoremove --purge docker-compose
    ```
    使用pip3 install docker-compose 安装docker-compose
    添加ansible_python_interpreter=/usr/bin/python3 在invertory文件
    如:
    ```
    localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3
    ```
6. Ansbile Docker module登录私有Docker服务器后证书保存失败 
    ```
    msg": "Logging into 192.168.4.239 for user Simon.Feng failed - Credentials store error: StoreError(`docker-credential-secretservice not installed or not available in PATH`,)"
    ```
    解决方案:  
    在被控主机上修改~/.docker/config.json 移除credsStore 节点 修改后如下
     ```
     {
          "auths": {},
               "HttpHeaders": {
                    "User-Agent": "Docker-Client/18.09.7 (linux)"
          }
     }
     ```
7. 使用Docker remote API 出错
    ```
    Error: (HTTP code 500) server error - cannot stop container: d5def4bd7ca97dcf15ee0d2a01221a5fe52728a6b84518752762ba2b3ecf4a8a: Cannot kill container d5def4bd7ca97dcf15ee0d2a01221a5fe52728a6b84518752762ba2b3ecf4a8a: unknown error after kill: runc did not terminate sucessfully: container_linux.go:388: signaling init process caused "permission denied"
    : unknown
    ```
    解决方案:  
    执行命令 
    ```
    aa-remove-unknown
    ```