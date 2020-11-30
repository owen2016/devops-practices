#!/bin/sh
# This script will upload all local images to a registry server ($registry is the default value).
# Usage: push_all
# Author: 
# Create: 2016-05-26

for image in `sudo docker images|grep -v "REPOSITORY"|grep -v "<none>"|awk '{print $1":"$2}'` 
do
    ./push.sh $image
done