# ELK (Elasticsearch+Filebeat+Logstash+kibana) 收集并显示业务容器的日志

### 一 安装并配置Filebeat
1. 下载deb包
>curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.0.0-amd64.deb

2. 到包所在目录安装
 >sudo dpkg -i filebeat-7.0.0-amd64.deb

3. 复制配置文件
>mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat-bk.yml

4. 添加配置文件
>vim /etc/filebeat/filebeat.yml

5. 启动Filebeat
>service filebeat start

6. 检查Filebeat启动状态
>service filebeat status

6. 设置开机自启
>systemctl enable filebeat

　第四步：加入配置信息如下，filebeat.inputs的containers的path按实际情况修改;output.logstash输出组件hosts按实际情况修改
```conf
filebeat.inputs:
- type: docker
  enabled: true
  containers:
    path: "/data01/docker/containers"
    ids:
      - "*"
  processors:
    - add_docker_metadata: ~
  multiline.pattern: '\d{2}:\d{2}:\d{2}.\d{3}'
  multiline.negate: true
  multiline.match: after
output.logstash:
  hosts: ["172.20.222.179:5044"]
```

### 二 安装并配置Logstash

#### 一 前置条件
1. 已经安装了JDK1.8

#### 二 安装配置
1. 下载tar包
    下载地址https://artifacts.elastic.co/downloads/logstash/logstash-7.0.0.tar.gz

2. 检查是否可以正常启动
    1). 运行命令：bin/logstash -e 'input { stdin { } } output { stdout {} }'
	2). 在标准输出中输入测试字符，回车，查看打印信息

3. 添加配置文件
    1). 进入logstash-7.0.0目录添加配置文件logstash.conf
	2). 配置参考下方

4. 启动logstash
>bin/logstash -f logstash.conf

 
    第三步：加入配置信息如下，filter条件和output条件和elasticsearch hosts具体ip地址按实际情况修改
```conf
input {
    beats {
        port => "5044"
    }
}
filter {
    if ![container][labels][io_kubernetes_container_name] {
        drop { }
    }
}
output {
    if "[env=dev]" in [message] {
        elasticsearch {
            hosts => ["172.20.222.195:9200"]
            index => "logstash-dev-%{+YYYY.MM.dd}"
        }
    }

    if "[env=test]" in [message] {
        elasticsearch {
            hosts => ["172.20.222.195:9200"]
            index => "logstash-test-%{+YYYY.MM.dd}"
        }
    }

    if "[env=stage]" in [message] {
        elasticsearch {
            hosts => ["172.20.222.195:9200"]
            index => "logstash-stage-%{+YYYY.MM.dd}"
        }
    }

    if "[env=uat]" in [message] {
        elasticsearch {
            hosts => ["172.20.222.195:9200"]
            index => "logstash-uat-%{+YYYY.MM.dd}"
        }
    }

    if "[env=pts]" in [message] {
        elasticsearch {
            hosts => ["172.20.222.195:9200"]
            index => "logstash-pts-%{+YYYY.MM.dd}"
        }
    }

    if "[env=prod]" in [message] {
        elasticsearch {
            hosts => ["172.20.222.195:9200"]
            index => "logstash-prod-%{+YYYY.MM.dd}"
        }
    }
}
```