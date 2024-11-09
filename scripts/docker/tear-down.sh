#!/bin/bash

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")
source ${SCRIPT_PATH}/inc/functions.sh

conf ${1}

msg $danger "\nDocker clean up"

CONTAINERS=$(docker ps -q --filter "name=${TAK_ALIAS}")

if [ -n "${CONTAINERS}" ];then
    msg $warn "\nStopping containers: ${TAK_ALIAS}"
    docker stop ${CONTAINERS}

    msg $warn "\nRemoving containers: ${TAK_ALIAS}"
    docker rm ${CONTAINERS}
else
    msg $warn "\nNo containers found with prefix: ${TAK_ALIAS}"
fi

VOLUME=${TAK_ALIAS}_tak_data
if docker volume inspect "${VOLUME}" >/dev/null 2>&1; then
    msg $warn "\nRemoving Volume: ${VOLUME}"
    docker volume rm ${VOLUME}
else
    msg $warn "\nNo volume found: ${VOLUME}"
fi

NETWORK=${TAK_ALIAS}_taknet
if [ -n "$(docker network ls -f name=${NETWORK} -q)" ]; then
    msg $warn "\nRemoving Network: ${NETWORK}"
    docker network rm ${NETWORK}
else
    msg $warn "\nNo network found: ${NETWORK}"
fi

if [ -d "${RELEASE_PATH}" ];then
    if [ -d "${RELEASE_PATH}/tak/certs/files" ];then
        ${SCRIPT_PATH}/cert-bundler.sh ${TAK_ALIAS}
    fi 

    msg $danger "\nWiping ${RELEASE_PATH}"
    rm -rf ${RELEASE_PATH}
fi


