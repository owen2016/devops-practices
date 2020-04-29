#!/bin/bash
set -e

JOB="${JOB:-"spring-boots-demo"}"
ENV="${ENV:-"dev"}"
HARBOR="${HARBOR:-"harbor.augcloud.com"}"
SERVICES=(spring-boot-eureka spring-boot-hello)

if [ "${JOB}" == "spring-boots-demo" ]; then
    mvn clean install -Dmaven.test.skip=true
    docker-compose build --build-arg "env=${ENV}"

    for service in "${SERVICES[@]}"; do
        MODULE_NAME=$(echo "${service}" | awk -F "/" '{print $1}')
        IMAGE_NAME=${HARBOR}/augops/${MODULE_NAME}
        echo "=============================================="
        echo "tag image: ${MODULE_NAME} to ${IMAGE_NAME}"
        echo "=============================================="
        docker tag "${MODULE_NAME}" "${IMAGE_NAME}"
    done

    for service in "${SERVICES[@]}"; do
        MODULE_NAME=$(echo "${service}" | awk -F "/" '{print $1}')
        IMAGE_NAME=${HARBOR}/augops/${MODULE_NAME}
        echo "=============================================="
        echo "upload image: ${IMAGE_NAME}"
        echo "=============================================="
        docker push "${IMAGE_NAME}"
    done
fi