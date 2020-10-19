#!/bin/sh
# 监控各网站首页

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


function test_domain {
        local domain=$1
        status=`curl -s -o /dev/null -I -w "%{http_code}" $domain`

        if [ $status -eq '404' ]
        then
          printf "${domain}${RED}  ${status}${NC}\n"
        else
          printf "$domain$GREEN  $status$NC\n"
        fi

}


domain_list=$'bixuebihui.cn\nwww.bixuebihui.cn\ndev.bixuebihui.cn\nblog.bixuebihui.cn\nbixuebihui.com\nwww.bixuebihui.com'

while read -r domain; do
#       echo "... $domain ..."
   test_domain "http://$domain"
   test_domain "https://$domain"

done <<< "$domain_list"