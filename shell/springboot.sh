#!/bin/bash --login

# 获取进程ID
cur_dir=$(cd "$(dirname "$0")"; pwd)
echo $cur_dir
appname=$(basename $cur_dir)
echo $appname
ProcessID=$(ps -ef |grep $appname|grep -v 'grep'|awk '{print $2}')
echo $ProcessID

RootDir=${cur_dir}
echo $RootDir
#JVM 参数设置
JAVA_OPTS=" -server -Xmx512m -Xms256m -XX:+UseConcMarkSweepGC"
#ROCKETMQ 参数设置
#默认把log放到当前工作目录，和其他应用分开，否则默认情况下都输出到1个文件 不利于定位
ROCKETMQ_OPTS=" -Drocketmq.client.logRoot=$cur_dir"
#EXEC=nohup java ${JAVA_OPTS}  ${ROCKETMQ_OPTS} -Dappname=${appname} -jar main.jar > nohup.log 2>&1 &
EXEC=nohup java ${JAVA_OPTS} -Dappname=${appname} -jar main.jar > nohup.log 2>&1 &

if [[ $ProcessID ]];then # 这里判断进程是否存在
    echo "[info]当前通过ps检测进程ID为:$ProcessID"
    echo "[error]开始重启tomcat"
    kill -9 $ProcessID  # 杀掉进程
    sleep 3
    cd $RootDir
    $EXEC
else
echo "[error]进程不存在!开始自动重启..."
    cd $RootDir
    $EXEC
fi
echo "------------------------------"