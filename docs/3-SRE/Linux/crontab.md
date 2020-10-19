# crontab 周期执行任务 

以下基于ubuntu 16.04

## crontab主要作用
> 假如我们每天需要清空日志记录文件，我们可以执行一段指令去完成，每天都需要手动输入就比较麻烦，让系统每天去帮我们完成就比较轻松了，根据你自己的定义 可以定位到月 日 时 分 星期.


**1. 计划任务，crontab命令选项:**
* -u指定一个用户
* -l列出某个用户的任务计划
* -r删除某个用户的任务
* -e编辑某个用户的任务

**2. cron文件语法:**
> 可用crontab -e命令来编辑,编辑的是/var/spool/cron下对应用户的cron文件,也可以直接修改/etc/crontab文件

* "*"代表取值范围内的数字
* "/"代表"每"
* "-"代表从某个数字到某个数字
* ","分开几个离散的数字

| 分 | 小时 | 日 |  月 | 星期 | 命令 |
| :----:| :----: | :----: | :----: | :----: | :----: |
| 0-59 | 0-23 | 1-31 | 1-12 | 0-6 | command |


**3. 查看计划任务**
> 查看调度任务
> 
> crontab -l //列出当前的所有调度任务
> 
> crontab -l -u jp   //列出用户jp的所有调度任务

#### crontab实例
(1) 在当前home目录下创建shell[脚本](./scripts/sort.sh)sort.sh（实现排序）如下：
```bash
#!/bin/bash
arr=(1 5 4 5 6 7 0)
for (( i=0 ; i<${#arr[@]} ; i++ ))
do
  for (( j=${#arr[@]} - 1 ; j>i ; j-- ))
    do
     #echo $j
       if  [[ ${arr[j]} -lt ${arr[j-1]} ]]
       then
            t=${arr[j]}
            arr[j]=${arr[j-1]}
            arr[j-1]=$t
       fi
      done
 done
echo "排序后:"
echo ${arr[@]}
```
（2）输入crontab -e 添加计划任务（不指定用户就是当前用户）
> 第一次会让你选择编译器，如果选错编译器了要更改编译器  输入   select-editor 重新选择
> 
> ubuntu截图用shift+PrintScreen 选择 ’复制到剪切板‘ 就可以了

（3）在文本最后输入我们要执行的shell脚本命令
> \* * * * * 代表每分钟执行一次

（4）   重启cron服务：
```bash
service cron restart
```
（5）查看结果
> 用户home目录下查看任务有没有执行，如果执行了应该是有pa.txt文件的（任务有重定向到文件）
> 
> 如果你要周期执行python脚本，你只需要把脚本写好，然后将cron那里的执行命令写成    python3 脚本目录文件名就可以
> 比如 ：
```bash
* * * * *  python3 ~/hello.py >  123.txt
```

## 总结
> linux中将一个脚本文件作为一个计划任务小结，以python脚本为例：

1. 创建脚本test.py，在文件开头需要加上下面一行
   > #!/usr/bin/python
2. 给该文件添加可执行的权限
   > chmod  +x  test.py
3. 添加计划任务
   > crontab -e
   >
   > 在文件中追加一行，*/2 * * * * /usr/bin/python /home/pc/work/ENV/project/test.py
   > 保存退出，:wq
4. 重启cron服务
   > service cron restart


参考链接：https://blog.csdn.net/qq_38228830/article/details/80545004