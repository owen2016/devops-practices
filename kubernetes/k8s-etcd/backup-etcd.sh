#!/bin/sh
 
source /etc/profile
nowtime=`date +%Y%m%d%H%M`
# 备份的数据目录
workdir="/data/etcd-bak"
# etcd的数据目录
datadir="/data/etcd"
ep=`/sbin/ip addr|grep eth0|sed -nr 's#^.*inet (.*)/22.*$#\1#gp'`
capath="/etc/kubernetes/ssl/ca.pem"
certpath="/etc/etcd/ssl/etcd.pem"
keypath="/etc/etcd/ssl/etcd-key.pem"
etcdctlpath="--endpoints "https://${ep}:2379" --cacert=$capath --cert=$certpath --key=$keypath"
hostname=`hostname`
alertcontent="$hostname-etcd-bak-is-false-please-check-etcd-${nowtime}"
# 备份数据保留天数
delday=7
s3path="s3://etcd/etcd-${ep}"
s3alertcontent="$hostname-etcd-snapshot-to-s3-false-please-check"
etcdctlcmd=`whereis etcdctl|awk '{print $NF}'`
 
 
function deloldbak () {
find $workdir -name "etcd-*.gz" -mtime +${delday}|xargs rm -f
}
 
if [ ! -f /data/etcd-bak/etcd-${nowtime}.tar.gz ];then
mkdir -p /data/etcd-bak/etcd-${nowtime}/
else
echo "need wait to next time"
echo "need wait to next time" >>$workdir/etcd-bak.log
exit 1
fi
 
echo "===================================  begin $nowtime =================================="
echo "===================================  begin $nowtime ==================================" >>$workdir/etcd-bak.log
export ETCDCTL_API=3
echo "===================================  run snapshoting =================================" >>$workdir/etcd-bak.log
$etcdctlcmd $etcdctlpath  snapshot save $workdir/etcd-${nowtime}/snap-${nowtime}.db >>$workdir/etcd-bak.log
echo "===================================  run snapshoting =================================" >>$workdir/etcd-bak.log
if [ $? -eq 0 ]
then
    echo "etcd snapshot etcd-${nowtime}/snap-${nowtime}.db is successful"
    echo "etcd snapshot etcd-${nowtime}/snap-${nowtime}.db is successful" >>$workdir/etcd-bak.log
else
    echo "etcd snapshot etcd-${nowtime}/snap-${nowtime}.db is failed"
    echo "etcd snapshot etcd-${nowtime}/snap-${nowtime}.db is failed" >>$workdir/etcd-bak.log
fi
 
cp -fr $datadir/* $workdir/etcd-${nowtime}/
if [ $? -eq 0 ]
then
    echo "etcd snapshot etcd-${nowtime}/member is successful"
    echo "etcd snapshot etcd-${nowtime}/member is successful" >>$workdir/etcd-bak.log
else
    echo "etcd snapshot etcd-${nowtime}/member is failed"
    echo "etcd snapshot etcd-${nowtime}/member is failed" >>$workdir/etcd-bak.log
fi
 
 
$etcdctlcmd $etcdctlpath --write-out=table endpoint status
$etcdctlcmd $etcdctlpath --write-out=table endpoint status >>$workdir/etcd-bak.log
 
cd $workdir
tar zcf ./etcd-${nowtime}.tar.gz etcd-${nowtime}
rm -fr etcd-${nowtime}
aws s3 cp $workdir/etcd-${nowtime}.tar.gz $s3path/
if [ $? -eq 0 ]
then
    echo "etcd snapshot s3 is successful"
    echo "etcd snapshot s3 is successful" >>$workdir/etcd-bak.log
else
    echo "etcd snapshot s3 is failed"
    echo "etcd snapshot s3 is failed" >>$workdir/etcd-bak.log
fi
deloldbak
 
 
echo "===================================  end `date +%Y%m%d%H%M%S` =================================="
echo "===================================  end `date +%Y%m%d%H%M%S` ==================================" >>$workdir/etcd-bak.log