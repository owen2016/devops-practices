# Logstash-运行时参数

## 配置参数说明

### logstash.yml

/logstash/config/logstash.yml：主要用于控制logstash运行时的状态

参数|用途|默认值
:--|:--|:--
参数|用途|默认值
node.name|节点名称|主机名称
path.data|/数据存储路径 |LOGSTASH_HOME/data/
pipeline.workers|输出通道的工作workers数据量（提升输出效率）|cpu核数
pipeline.output.workers|每个输出插件的工作wokers数量|1
pipeline.batch.size|每次input数量|125
path.config|过滤配置文件目录|
config.reload.automatic|自动重新加载被修改配置|false or true
config.reload.interval|配置文件检查时间|
path.logs|日志输出路径|
http.host|绑定主机地址，用户指标收集|“127.0.0.1”
http.port|绑定端口|5000-9700
log.level|日志输出级别,如果config.debug开启，这里一定要是debug日志	info
log.format|日志格式 |* plain*
path.plugins|自定义插件目录|

### startup.options

/logstash/config/startup.options：logstash 运行相关参数

参数|用途
:--|:--|:--
JAVACMD=/usr/bin/java | 本地jdk
LS_HOME=/opt/logstash |logstash所在目录
LS_SETTINGS_DIR="${LS_HOME}/config" |	默认logstash配置文件目录
LS_OPTS="–path.settings ${LS_SETTINGS_DIR}"	 | logstash启动命令参数 指定配置文件目录
LS_JAVA_OPTS="" | 指定jdk目录
LS_PIDFILE=/var/run/logstash.pid |	logstash.pid所在目录
LS_USER=logstash |logstash启动用户
LS_GROUP=logstash | logstash启动组
LS_GC_LOG_FILE=/var/log/logstash/gc.log | logstash jvm gc日志路径
LS_OPEN_FILES=65534 | logstash最多打开监控文件数量

## 从命令行运行Logstash

- https://segmentfault.com/a/1190000016602985