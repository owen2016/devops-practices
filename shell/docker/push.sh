#!/bin/bash
# This script will upload the given local images to a registry server ($registry is the default value).
# Usage: push_images image1 [image2...]
# Author: 
# Create: 2016-05-26

#The registry server address where you want push the images into(Please instead of your private registry's domain name)
registry=xxxxxxxx

### DO NOT MODIFY THE FOLLOWING PART, UNLESS YOU KNOW WHAT IT MEANS. YOU CAN ALSO LEARN IT FROM HERE.###
echo_g () {
    [ $# -ne 1 ] && return 0
    echo -e "\033[32m$1\033[0m"
}
echo_b () {
    [ $# -ne 1 ] && return 0
    echo -e "\033[34m$1\033[0m"
}

usage() {
    sudo docker images
    echo "Usage: $0 registry1:tag1 [registry2:tag2...]"
}

[ $# -lt 1 ] && usage && exit

echo_b "The registry server is $registry"

for image in "$@"
    do
        echo_b "Uploading $image..."
        sudo docker tag $image $registry/$image
        sudo docker push $registry/$image
        sudo docker rmi $registry/$image
        echo_g "Push $image success!"
    done