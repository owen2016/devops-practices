# nginx
实时统计nginx日志
使用goaccess软件，可能用apt install goaccess或yum install goaccess安装。

sudo goaccess /var/log/nginx/access.log --log-format='%h %^[%d:%t %^] "%r" %s %b "%R" "%u" "-" "%v"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S'


nginx 自动筛选出访问量过大的ip进行屏避

```
#!/bin/bash
nginx_home=/etc/nginx
log_path=/var/log/nginx
tail -n10000 $log_path/access.log \
      |awk '{print $1,$12}' \
      |grep -i -v -E "google|yahoo|baidu|msnbot|FeedSky|sogou" \
      | grep -v '223.223.198.231' \
      |awk '{print $1}'|sort|uniq -c|sort -rn \
      |awk '{if($1>50)print "deny "$2";"}' >>./blockips.conf

sort ./blockips.conf |uniq -u  >./blockips_new.conf
mv ./blockips.conf ./blockips_old.conf
mv ./blockips_new.conf ./blockips.conf
cat ./blockips.conf
#service nginx  reload
```

备份nginx配置文件
nginx会频繁修改，改之前最好备份一下：

```
###################################################################
#######mysqldump###################################################
#!/bin/sh
# -----------------------------
# the directory for story your backup file.
backup_dir="/home/your/backup"

# date format for backup file (dd-mm-yyyy)
time="$(date +"%Y%m%d")"

MKDIR="$(which mkdir)"
RM="$(which rm)"
MV="$(which mv)"
TAR="$(which tar)"
GZIP="$(which gzip)"

#针对不同系统，如果环境变量都有。可以去掉

# check the directory for store backup is writeable
test ! -w $backup_dir && echo "Error: $backup_dir is un-writeable." && exit 0

# the directory for story the newest backup
test ! -d "$backup_dir" && $MKDIR "$backup_dir"


$TAR -zcPf $backup_dir/$HOSTNAME.nginx.$time.tar.gz  /etc/nginx
$TAR -zcPf $backup_dir/$HOSTNAME.cron_daily.$time.tar.gz  /etc/cron.daily

#delete the oldest backup 30 days ago
find $backup_dir -name "*.gz" -mtime +30 |xargs rm -rf

exit 0;
```