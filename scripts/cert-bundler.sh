#!/bin/bash

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
source ${SCRIPT_PATH}/inc/functions.sh

conf ${1}

TAK_CERT_BUNDLE=${TAK_ALIAS}.tak.certs.zip
BUNDLE_BACKUP="${TAK_ALIAS}.tak.certs.$(date +%s).zip"

BUNDLE="${RELEASE_PATH}/${TAK_CERT_BUNDLE}"
cd ${RELEASE_PATH}/tak/certs/
zip -r "${BUNDLE}" * > "${BUNDLE}.log" 2>&1
msg $info "\nCreated cert bundle: ${BUNDLE}" 

mkdir -p ${ROOT_PATH}/release/cert-backup

if [ "${2}" != "false" ]; then
    cp -f ${BUNDLE} ${ROOT_PATH}/release/cert-backup/${BUNDLE_BACKUP}
fi

echo