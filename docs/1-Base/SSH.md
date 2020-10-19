# SSH 免密登录

为什么设置免密登录及远程拷贝？

- 方便操作，处理快速；
- 计算机集群中机器之间有频繁的数据交换需求。

设置方法：（假设A、B计算机要进行加密通信）
A计算机root用户的命令行输入ssh-keygen –t rsa，生成密钥对；
若B计算机授权给A免密钥登录B，则将A计算机的公钥放入B计算机的authorized_keys文件中。

通俗理解设置：将计算机的信任关系与人之间的信任关系作类比。张三若信任李四，则表示李四在张三的受信任名单的列表中（类比A计算机的公钥放到B计算机的authorized_keys文件中）。

这里介绍 如何配置控制主机到目标主机root无密码SSH登录

ssh-keygen; ssh-copy-id user@host; ssh user@host

## 一. 开启ssh服务

### 1.查看本机是否装了ssh

Ubuntu16.04默认只会安装ssh客户端，不会安装ssh服务器，可通过sudo dpkg -l | grep ssh 查看：

![Linux-ssh-keygen(免密登录)-5.png](./images/Linux-ssh-keygen(免密登录)-5.png)

### 2.安装ssh server

首先更新源 sudo apt-get update

然后安装openssh sudo apt-get install openssh-server

### 3.安装ssh client (若已经安装，可忽略)

sudo apt-get install openssh-client

### 4.等待安装完成，查看ssh安装情况  

dpkg -l | grep ssh

![Linux-ssh-keygen(免密登录)-6.png](./images/Linux-ssh-keygen(免密登录)-6.png)

### 5.查看ssh service的状态  

systemctl status ssh

![Linux-ssh-keygen(免密登录)-7.png](./images/Linux-ssh-keygen(免密登录)-7.png)

如果不是active(running)的状态，可以通过此命令去启：
sudo /etc/init.d/ssh start

### 6.查看service进程和监听的端口

/etc/init.d/ssh status or ps -e | grep ssh

![Linux-ssh-keygen(免密登录)-8.png](./images/Linux-ssh-keygen(免密登录)-8.png)

## 二.开启Root登陆

### 1.设置root密码

ubuntu 16.04装完系统之后，默认用户不是root，使用root用户需要先设置root的密码:
sudo passwd root

![Linux-ssh-keygen(免密登录)-9.png](./images/Linux-ssh-keygen(免密登录)-9.png)

### 2.设置root ssh登陆

修改配置文件 sudo vim /etc/ssh/sshd_config
修改为如下配置：

> 如果系统不认识vim命令，可以通过此命令安装：sudo apt-get install vim

![Linux-ssh-keygen(免密登录)-10.png](./images/Linux-ssh-keygen(免密登录)-10.png)

### 3.重启ssh

sudo service ssh restart

此时可以用putty连此机器，并用root用户登陆

## 三.设置本地root免密登陆

### 1.登陆到root用户下

su root #输入密码登陆
cd ~ #进入到根目录

### 2.生成ssh公钥 

ssh-keygen -t rsa  
一直回车即可

![Linux-ssh-keygen(免密登录)-11.png](./images/Linux-ssh-keygen(免密登录)-11.png)

### 3.公钥追加到 authorized_keys 文件中

cat .ssh/id_rsa.pub >> .ssh/authorized_keys

### 4.赋予 authorized_keys 文件权限

chmod 600 .ssh/authorized_keys

### 5.验证是否成功

ssh localhost #可能第一次需要密码，以后便不需要了

## 四.设置远程登陆

### 1.在控制主机上生成密钥 

ssh-keygen -t dsa
ssh-keygen -t rsa -如果已经生成可以跳过

加密方式选 rsa|dsa均可以，默认dsa

其中：id_rsa为私钥文件，id_rsa.pub为公钥文件

![Linux-ssh-keygen(免密登录)-1.png](./images/Linux-ssh-keygen(免密登录)-1.png)

### 2.ssh-copy-id -i    ~/.ssh/id_rsa.pub  remote-host

ssh-copy-id 将本机的公钥复制到远程机器的authorized_keys文件中，ssh-copy-id 也能让你有到远程机器的home, ~./ssh , 和 ~/.ssh/authorized_keys的权利

![Linux-ssh-keygen(免密登录)-1.png](./images/Linux-ssh-keygen(免密登录)-2.png)  

ssh-copy-id 如何使用非22端口
ssh-copy-id  -i ~/.ssh/id_rsa.pub  "-p 2122  root@IP "

### 3.ssh remote-host  -登录到远程机器不用输入密码 

![Linux-ssh-keygen(免密登录)-1.png](./images/Linux-ssh-keygen(免密登录)-3.png)

![Linux-ssh-keygen(免密登录)-1.png](./images/Linux-ssh-keygen(免密登录)-4.png)

## ssh-keygen参数说明**

```text
ssh-keygen - 生成、管理和转换认证密钥
     ssh-keygen [-q] [-b bits] -t type [-N new_passphrase] [-C comment] [-foutput_keyfile]
     ssh-keygen -p [-P old_passphrase] [-N new_passphrase] [-f keyfile]
     ssh-keygen -i [-f input_keyfile]
     ssh-keygen -e [-f input_keyfile]
     ssh-keygen -y [-f input_keyfile]
     ssh-keygen -c [-P passphrase] [-C comment] [-f keyfile]
     ssh-keygen -l [-f input_keyfile]
     ssh-keygen -B [-f input_keyfile]
     ssh-keygen -D reader
     ssh-keygen -F hostname [-f known_hosts_file]
     ssh-keygen -H [-f known_hosts_file]
     ssh-keygen -R hostname [-f known_hosts_file]
     ssh-keygen -U reader [-f input_keyfile]
     ssh-keygen -r hostname [-f input_keyfile] [-g]
     ssh-keygen -G output_file [-v] [-b bits] [-M memory] [-S start_point]
     ssh-keygen -T output_file -f input_file [-v] [-a num_trials] [-W generator]
     ssh-keygen 用于为
生成、管理和转换认证密钥，包括 RSA 和 DSA 两种密钥。
     密钥类型可以用 -t 选项指定。如果没有指定则默认生成用于SSH-2的RSA密钥。
     ssh-keygen 还可以用来产生 Diffie-Hellman group exchange (DH-GEX) 中使用的素数模数。
     参见模数和生成小节。
     一般说来，如果用户希望使用RSA或DSA认证，那么至少应该运行一次这个程序，
     在 ~/.ssh/identity, ~/.ssh/id_dsa 或 ~/.ssh/id_rsa 文件中创建认证所需的密钥。
     另外，系统管理员还可以用它产生主机密钥。
 通常，这个程序产生一个密钥对，并要求指定一个文件存放私钥，同时将公钥存放在附加了".pub"后缀的同名文件中。
     程序同时要求输入一个密语字符串(passphrase)，空表示没有密语(主机密钥的密语必须为空)。
     密语和口令(password)非常相似，但是密语可以是一句话，里面有单词、标点符号、数字、空格或任何你想要的字符。
     好的密语要30个以上的字符，难以猜出，由大小写字母、数字、非字母混合组成。密语可以用 -p 选项修改。
     丢失的密语不可恢复。如果丢失或忘记了密语，用户必须产生新的密钥，然后把相应的公钥分发到其他机器上去。
     RSA1的密钥文件中有一个"注释"字段，可以方便用户标识这个密钥，指出密钥的用途或其他有用的信息。
     创建密钥的时候，注释域初始化为"user@host"，以后可以用 -c 选项修改。
     密钥产生后，下面的命令描述了怎样处置和激活密钥。可用的选项有：
     -a trials
             在使用 -T 对 DH-GEX 候选素数进行安全筛选时需要执行的基本测试数量。
     -B      显示指定的公钥/私钥文件的 bubblebabble 摘要。
     -b bits
             指定密钥长度。对于RSA密钥，最小要求768位，默认是2048位。DSA密钥必须恰好是1024位(FIPS 186-2 标准的要求)。
     -C comment
             提供一个新注释
     -c      要求修改私钥和公钥文件中的注释。本选项只支持 RSA1 密钥。
             程序将提示输入私钥文件名、密语(如果存在)、新注释。
     -D reader
             下载存储在智能卡 reader 里的 RSA 公钥。
     -e      读取OpenSSH的私钥或公钥文件，并以 RFC 4716 SSH 公钥文件格式在 stdout 上显示出来。
             该选项能够为多种商业版本的 SSH 输出密钥。
     -F hostname
             在 known_hosts 文件中搜索指定的 hostname ，并列出所有的匹配项。
             这个选项主要用于查找散列过的主机名/ip地址，还可以和 -H 选项联用打印找到的公钥的散列值。
     -f filename
             指定密钥文件名。
     -G output_file
             为 DH-GEX 产生候选素数。这些素数必须在使用之前使用 -T 选项进行安全筛选。
     -g      在使用 -r 打印指纹资源记录的时候使用通用的 DNS 格式。
     -H      对 known_hosts 文件进行散列计算。这将把文件中的所有主机名/ip地址替换为相应的散列值。
             原来文件的内容将会添加一个".old"后缀后保存。这些散列值只能被 ssh 和 sshd 使用。
             这个选项不会修改已经经过散列的主机名/ip地址，因此可以在部分公钥已经散列过的文件上安全使用。
     -i      读取未加密的SSH-2兼容的私钥/公钥文件，然后在 stdout 显示OpenSSH兼容的私钥/公钥。
             该选项主要用于从多种商业版本的SSH中导入密钥。
     -l      显示公钥文件的指纹数据。它也支持 RSA1 的私钥。
             对于RSA和DSA密钥，将会寻找对应的公钥文件，然后显示其指纹数据。
     -M memory
             指定在生成 DH-GEXS 候选素数的时候最大内存用量(MB)。
     -N new_passphrase
             提供一个新的密语。
     -P passphrase
             提供(旧)密语。
     -p      要求改变某私钥文件的密语而不重建私钥。程序将提示输入私钥文件名、原来的密语、以及两次输入新密语。
     -q      安静模式。用于在 /etc/rc 中创建新密钥的时候。
     -R hostname
             从 known_hosts 文件中删除所有属于 hostname 的密钥。
             这个选项主要用于删除经过散列的主机(参见 -H 选项)的密钥。
     -r hostname
             打印名为 hostname 的公钥文件的 SSHFP 指纹资源记录。
     -S start
             指定在生成 DH-GEX 候选模数时的起始点(16进制)。
     -T output_file
             测试 Diffie-Hellman group exchange 候选素数(由 -G 选项生成)的安全性。
     -t type
             指定要创建的密钥类型。可以使用："rsa1"(SSH-1) "rsa"(SSH-2) "dsa"(SSH-2)
     -U reader
             把现存的RSA私钥上传到智能卡 reader
     -v      详细模式。ssh-keygen 将会输出处理过程的详细调试信息。常用于调试模数的产生过程。
             重复使用多个 -v 选项将会增加信息的详细程度(最大3次)。
     -W generator
             指定在为 DH-GEX 测试候选模数时想要使用的 generator
     -y      读取OpenSSH专有格式的公钥文件，并将OpenSSH公钥显示在 stdout 上。
     ssh-keygen 可以生成用于 Diffie-Hellman Group Exchange (DH-GEX) 协议的 groups 。
     生成过程分为两步：
     首先，使用一个快速且消耗内存较多的方法生成一些候选素数。然后，对这些素数进行适应性测试(消耗CPU较多)。
     可以使用 -G 选项生成候选素数，同时使用 -b 选项制定其位数。例如：
           # ssh-keygen -G moduli-2048.candidates -b 2048
     默认将从指定位数范围内的一个随机点开始搜索素数，不过可以使用 -S 选项来指定这个随机点(16进制)。
     生成一组候选数之后，接下来就需要使用 -T 选项进行适应性测试。
     此时 ssh-keygen 将会从 stdin 读取候选素数(或者通过 -f 选项读取一个文件)，例如：
           # ssh-keygen -T moduli-2048 -f moduli-2048.candidates
     每个候选素数默认都要通过 100 个基本测试(可以通过 -a 选项修改)。
     DH generator 的值会自动选择，但是你也可以通过 -W 选项强制指定。有效的值可以是： 2, 3, 5
     经过筛选之后的 DH groups 就可以存放到 /etc/ssh/moduli 里面了。
     很重要的一点是这个文件必须包括不同长度范围的模数，而且通信双方双方共享相同的模数。
     ~/.ssh/identity
             该用户默认的 RSA1 身份认证私钥(SSH-1)。此文件的权限应当至少限制为"600"。
             生成密钥的时候可以指定采用密语来加密该私钥(3DES)。

将在登录的时候读取这个文件。
     ~/.ssh/identity.pub
             该用户默认的 RSA1 身份认证公钥(SSH-1)。此文件无需保密。
             此文件的内容应该添加到所有 RSA1 目标主机的 ~/.ssh/authorized_keys 文件中。
     ~/.ssh/id_dsa
             该用户默认的 DSA 身份认证私钥(SSH-2)。此文件的权限应当至少限制为"600"。
             生成密钥的时候可以指定采用密语来加密该私钥(3DES)。

将在登录的时候读取这个文件。
     ~/.ssh/id_dsa.pub
             该用户默认的 DSA 身份认证公钥(SSH-2)。此文件无需保密。
             此文件的内容应该添加到所有 DSA 目标主机的 ~/.ssh/authorized_keys 文件中。
     ~/.ssh/id_rsa
             该用户默认的 RSA 身份认证私钥(SSH-2)。此文件的权限应当至少限制为"600"。
             生成密钥的时候可以指定采用密语来加密该私钥(3DES)。

将在登录的时候读取这个文件。
     ~/.ssh/id_rsa.pub
             该用户默认的 RSA 身份认证公钥(SSH-2)。此文件无需保密。
             此文件的内容应该添加到所有 RSA 目标主机的 ~/.ssh/authorized_keys 文件中。
     /etc/ssh/moduli
             包含用于 DH-GEX 的 Diffie-Hellman groups 。

```
