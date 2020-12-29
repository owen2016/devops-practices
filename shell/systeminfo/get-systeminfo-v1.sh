#!/bin/bash

# 获取系统信息
# 获取系统版本
get_system_version(){
    cat /etc/issue
}

# 获取host name
get_system_hostname(){
    hostname
}

# 获取物理cpu数量
get_physical_cpu_num(){
    cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
}

# 获取逻辑cpu数量
get_logic_cpu_num(){
    cat /proc/cpuinfo |grep "processor"|wc -l
}

# 获取cpu数量几核
get_core_cpu_num(){
    grep "cpu cores" /proc/cpuinfo | head -n1 | awk '{ print $NF }'
}

# 获取cpu model name信息
get_cpu_model_name_info(){
    cat /proc/cpuinfo | grep -E "model name|processor"
}

# 获取所有内存信息
get_all_memory_info(){
    free -m
}

# 获取总内存
get_memory_total(){
    free -m | awk 'NR==2{ print $2 }'
}

# 获取可用内存
get_memory_free(){
    free -m | awk 'NR==2{ print $NF }'
}

# 获取所有文件系统的详细信息
get_all_disk_info(){
    df -h
}

# 获取挂载到根目录的文件系统的总大小
get_disk_size(){
    df -h | grep -E "^.*/$" | awk '{ print $2 }'
}

# 获取系统位数
get_system_bit(){
    getconf LONG_BIT
}

# 获取当前系统正在运行的进程数
get_process(){
    ps aux | tail -n +2 | wc -l
}

# 获取已安装的软件包数量
get_software_num(){
    dpkg -l | tail -n +6 | wc -l
}

# 获取ip
get_ip(){
    ip a s | grep -w "inet" | awk 'NR==2{ print $2 }' | awk -F/ '{ print $1 }'
}

# 获取所有网络信息
get_all_net_config_info() {
    ifconfig
}

# 获取防火墙配置
get_iptable_info() {
    iptables -L
}

# 获取路由信息
get_route_info() {
    route -n
}

# 获取端口监听信息
get_netstat_info() {
    netstat -lntp
}

echo "system version: $(get_system_version)"
echo "system hostname: $(get_system_hostname)"
echo "physical cpu num: $(get_physical_cpu_num)"
echo "logic cpu num: $(get_logic_cpu_num)"
echo "cpu cores num: $(get_core_cpu_num)"
echo "cpu model name info: $(get_cpu_model_name_info)"
echo "all memory info: $(get_all_memory_info)"
echo "memory total: $(get_memory_total)M"
echo "memory free: $(get_memory_free)M"
echo "all disk info: $(get_all_disk_info)"
echo "disk size: $(get_disk_size)"
echo "system bit: $(get_system_bit)"
echo "process: $(get_process)"
echo "software num: $(get_software_num)"
echo "all net config info: $(get_all_net_config_info)"
echo "iptable info: $(get_iptable_info)"
echo "system route info: $(get_route_info)"
echo "system listen port info: $(get_netstat_info)"