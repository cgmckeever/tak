#!/bin/bash

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")
source ${SCRIPT_PATH}/inc/functions.sh
source ${SCRIPT_PATH}/inc/configure.sh 

conf ${1}
CURRENT_VERSION=${VERSION}
BACKUP_PATH="${RELEASE_PATH}/backups/${CURRENT_VERSION}"

msg $info "\nPerforming TAK Server Docker Upgrade\n"

## TAK Package
#
source ${SCRIPT_PATH}/inc/package.sh
UPGRADE_VERSION=${VERSION}

source ${SCRIPT_PATH}/system.sh ${TAK_ALIAS} stop


## Create TAK file backups
#
${SCRIPT_PATH}/backup.sh ${TAK_ALIAS}


## Unpack, move certs, and restart
#
msg $info "\nUnpacking TAK ${UPGRADE_VERSION}\n"
rm -rf ${RELEASE_PATH}/tak
rm -rf ${RELEASE_PATH}/docker
${SCRIPT_PATH}/docker/unpack.sh ${TAK_PACKAGE} ${RELEASE_PATH}

msg $info "\nSyncing Config files\n"
filesync
coreconfig

cp ${BACKUP_PATH}/UserAuthenticationFile.${CURRENT_VERSION}.xml ${TAK_PATH}/UserAuthenticationFile.xml
sed -e "s/VERSION=${CURRENT_VERSION}/VERSION=${UPGRADE_VERSION}/g" \
	${BACKUP_PATH}/config.inc.${CURRENT_VERSION}.sh > ${RELEASE_PATH}/config.inc.sh

msg $info "\nSyncing cert bundle\n"
unzip ${RELEASE_PATH}/backups/${TAK_ALIAS}.tak.certs.zip -d ${RELEASE_PATH}/tak/certs/

source ${SCRIPT_PATH}/system.sh ${TAK_ALIAS} start

