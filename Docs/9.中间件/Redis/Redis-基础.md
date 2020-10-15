# redis 

### 下载
```
wget http://download.redis.io/releases/redis-5.0.3.tar.gz
tar -zxf redis-5.0.3.tar.gz

cd redis-5.0.3/
```

### 编译
```
# 需要gcc环境
apt-get install make build-essential

# 编译
make

# 编译后文件
ls src/

# copy编译后二进制文件到 /usr/local/bin

cp src/redis-cli /usr/local/bin
cp src/redis-server /usr/local/bin
```
****
`编译redis时报错zmalloc.h:50:31: 错误：jemalloc/jemalloc.h：`
可参考：　[http://blog.51cto.com/xvjunjie/2071671](http://blog.51cto.com/xvjunjie/2071671)
****

### 配置
```
mkdir -p /root/redis/data
```

`vim /root/redis/redis.conf`
```
port 6379
cluster-enabled yes
cluster-config-file "nodes.conf"
cluster-node-timeout 5000
cluster-require-full-coverage no
appendonly yes
daemonize yes
logfile "/var/log/redis.log"
requirepass "vivo123."
dir "/root/redis/data"
```

`启动：　redis-server /root/redis/redis.conf`

### 配置集群
3master 3 slave集群`(根据情况更改ip端口)`
```
redis-cli -a vivo123. --cluster create 172.20.222.190:6379  172.20.222.191:6379 172.20.222.192:6379 172.20.222.193:6379 172.20.222.194:6379 172.20.222.195:6379 --cluster-replicas 1
```

手动为某一台实例创建slave节点：
```
# 查看集群信息
redis-cli -a vivo123. cluster nodes

redis-cli -a vivo123. --cluster add-node 172.20.222.192:6378 172.20.222.192:6379 --cluster-slave --cluster-master-id a273a99c7592f126c2f9d395e04c2d35a2432fcc

# 说明
172.20.222.192:6378　新增备份节点
172.20.222.192:6379　以存在集群几点
a273a99c7592f126c2f9d395e04c2d35a2432fcc　为哪台master配置slave，master node id
```

停止redis服务：
```
redis-cli -a vivo123. shutdown
```

### master--slave配置
master 配置:
```
port 6379
bind 172.20.222.190
appendonly yes
daemonize yes
logfile "/var/log/redis.log"
requirepass "vivo123."
dir /data01/redis/data
```


slave 配置:
```
port 6379
bind 172.20.222.191
slaveof 172.20.222.190 6379
masterauth vivo123.
protected-mode no
appendonly yes
daemonize yes
logfile "/var/log/redis.log"
dir "/data01/redis/data"
```


## redis5.0安装与配置
### 安装步骤
1.下载及解压、编译redis-5.0.0.tar.gz:
```
$ wget http://download.redis.io/releases/redis-5.0.0.tar.gz
$ tar xzf redis-5.0.0.tar.gz
$ cd redis-5.0.0
$ make
```
2.启动Redis服务
```
$ src/redis-server
```
3.登录redis客户端
```
$ src/redis-cli
```
### 配置
1. 编辑redis配置文件，`sudo vim /redis-5.0.0/redis.conf`，修改以下配置项：
	```
	#设置为后台进程运行
	daemonize yes

	#注释bind，打开远程访问
	#bind 127.0.0.1

	#设置log的路径（自定义）
	logfile "/var/log/redis/logs/redis_log.log"

	#数据存储路径
	dir /usr/local/redis/redis_db

	#设置访问密码，取消注释
	requirepass redispassword
	```
2. 停止redis服务，`netstat -anp | grep redis`查看并终止redis-server进程；
3. 重启，`src/redis-server redis.conf`，这里需要带上配置文件，使配置文件生效；
4. 再次登录redis客户端，发现使用`src/redis-cli`登录，没有操作权限，需要带上密码：`src/redis-cli -a redispassword`；

参考： [https://ywnz.com/linuxrj/3349.html](https://ywnz.com/linuxrj/3349.html)
[https://www.cnblogs.com/xxoome/p/7121042.html](https://www.cnblogs.com/xxoome/p/7121042.html)
[https://www.cnblogs.com/zongfa/p/7808807.html](https://www.cnblogs.com/zongfa/p/7808807.html)