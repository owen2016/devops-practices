#!/bin/bash
 
# 使用etcdctl snapshot restore生成各个节点的数据
 
# 比较关键的变量是
# --data-dir 需要是实际etcd运行时的数据目录
# --name  --initial-advertise-peer-urls  需要用各个节点的配置
# --initial-cluster  initial-cluster-token 需要和原集群一致
# 注意http和https区别
 
# 无需更改
workdir=/root
 
# etcd1,2,3为节点名称 ETCD1,2,3为对应节点ip
ETCD_1=1.1.1.1
ETCD_2=2.2.2.2
ETCD_3=3.3.3.3
etcd1=etcd1
etcd2=etcd2
etcd3=etcd3
 
# 同上面一样需要对应设置
arra=(1.1.1.1 2.2.2.2 3.3.3.3)
arrb=(etcd1 etcd2 etcd3)
 
# etcd是否使用https tls加密如果使用需要配置证书，若是http请置空此变量
etcdkey="--cacert=/etc/kubernetes/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem"
# 恢复数据存放目录，只是用于恢复存放数据，可以随意设置，跟原有的路径没有关系
etcddatapath="/root/etcd-recover-data/etcd"
# 备份数据根路径
bakdatapath="/data/etcd-bak"
# 备份数据完整路径
bakdbpath="$bakdatapath/etcd-201906161945/snap-201906161945.db"
# ansible site执行路径
ansiblepath="/root/etcd-bak-ansible"
 
function ansibleoperate ()
{
rm -fr $ansiblepath/roles/etcd-bak-ansible/files/*
cp -fr $(echo $etcddatapath|awk -F "[/]" '{print "/"$2"/"$3}')/* $ansiblepath/roles/etcd-bak-ansible/files/
cd $ansiblepath
ansible-playbook -i hosts site.yaml
}
 
if [ ! -d $(echo $etcddatapath|awk -F "[/]" '{print "/"$2"/"$3}') ];then
mkdir -p $(echo $etcddatapath|awk -F "[/]" '{print "/"$2"/"$3}')
fi
 
for i in ${arra[@]}
do
echo -e "\t$i\c" >>$workdir/etcdiplist.log
#echo -e "$i"
done
 
 
for i in ${arrb[@]}
do
echo -e "\t$i\c" >>$workdir/etcdnamelist.log
#echo -e "$i"
done
 
while true
do
let cnt++
etcdiplist=`awk -v column=$cnt '{print $column}' $workdir/etcdiplist.log`
etcdnamelist=`awk -v column=$cnt '{print $column}' $workdir/etcdnamelist.log`
 
if [ "$etcdiplist" = "" ]
    then
        echo "conf is down will to break"
        break
fi
echo $etcdiplist $etcdnamelist
export ETCDCTL_API=3
# 如果用原有member中的db恢复，由于不存在完整的hash性，需要在下面添加 --skip-hash-check \ 跳过hash检查
etcdctl snapshot $etcdkey  restore $bakdbpath  \
--data-dir=$etcddatapath \
--name $etcdnamelist \
--initial-cluster ${etcd1}=https://${ETCD_1}:2380,${etcd2}=https://${ETCD_2}:2380,${etcd3}=https://${ETCD_3}:2380 \
--initial-cluster-token etcd-cluster-0 \
--initial-advertise-peer-urls https://$etcdiplist:2380 && \
mv $etcddatapath $(echo $etcddatapath|awk -F "[/]" '{print "/"$2"/"$3}')/etcd_$etcdiplist
 
echo "--initial-cluster ${etcd1}=https://${ETCD_1}:2380,${etcd2}=https://${ETCD_2}:2380,${etcd3}=https://${ETCD_3}:2380 "
 
 
done
 
rm -f $workdir/etcdiplist.log
rm -f $workdir/etcdnamelist.log
 
#如果不需要Ansible自动恢复集群，需要手动恢复的话请注释以下操作
ansibleoperate