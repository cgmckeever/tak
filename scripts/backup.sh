#!/bin/bash

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
source ${SCRIPT_PATH}/inc/functions.sh

conf ${1}

## Backup current TAK working directories 
#
${SCRIPT_PATH}/cert-bundler.sh ${TAK_ALIAS}

msg $info "\nCreating TAK ${VERSION} backup\n"

BACKUP_PATH="${RELEASE_PATH}/backups/${VERSION}"
mkdir -p ${BACKUP_PATH}

cp ${TAK_PATH}/CoreConfig.xml ${BACKUP_PATH}/CoreConfig.${VERSION}.xml
cp ${RELEASE_PATH}/config.inc.sh ${BACKUP_PATH}/config.inc.${VERSION}.sh
cp ${TAK_PATH}/UserAuthenticationFile.xml ${BACKUP_PATH}/UserAuthenticationFile.${VERSION}.xml

cd ${TAK_PATH}/..
BACKUP_ZIP="tak.${VERSION}.zip"
rm -rf ${BACKUP_PATH}/${BACKUP_ZIP}
if [[ "${INSTALLER}" == "docker" ]];then 
    DOCKER=docker
fi
zip -r ${BACKUP_PATH}/${BACKUP_ZIP} tak ${DOCKER}