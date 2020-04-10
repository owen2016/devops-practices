#!/bin/bash
#----------ubuntu18.04搭建k8s (v1.15.2)集群-------
#安装ftp客户端
sudo apt-get install lftp
#修改时区
ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
bash -c "echo 'Asia/Shanghai' > /etc/timezone"

#替换apt源为阿里源,先备份
echo "替换apt源为阿里源"
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo rm -f /etc/apt/sources.list.save
sudo cp -f sources.list /etc/apt
sudo apt-get update

#安装docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=5:19.03.2~3-0~ubuntu-bionic docker-ce-cli=5:19.03.2~3-0~ubuntu-bionic

#安装nvidia-container,请确保已经安装了nvidia显卡驱动
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
apt-get install -y nvidia-container-runtime

#docker配置文件
mkdir -p /etc/docker
cp -f daemon.json /etc/docker
systemctl daemon-reload
systemctl restart docker

#安装k8s组件
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt install -y kubelet=1.15.2-00 kubeadm=1.15.2-00 kubectl=1.15.2-00
sudo apt-mark hold kubelet=1.15.2-00 kubeadm=1.15.2-00 kubectl=1.15.2-00
cp -f 10-kubeadm.conf /etc/systemd/system/kubelet.service.d/

#dns设置
cp -f resolved.conf /etc/systemd/resolved.conf
systemctl restart systemd-resolved