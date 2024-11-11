#!/bin/bash

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")
source ${SCRIPT_PATH}/inc/functions.sh

TEMP_DIR=$(mktemp -d)
unzip ${1} -d ${TEMP_DIR}
mv ${TEMP_DIR}/*/* ${2}
rm -rf ${TEMP_DIR}
echo