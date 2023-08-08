#!/bin/bash

arch=$(dpkg --print-architecture)

WORK_DIR=~/tak-server # Base directory; where everything kicks off

#TAK_PATH="${WORK_DIR}/tak"
#CERT_PATH="${TAK_PATH}/certs"
#FILE_PATH="${CERT_PATH}/files"

#DOCKER_CERT_PATH="/opt/tak/certs"

TOOLS_PATH=$(dirname $(dirname $(dirname $SCRIPT_PATH)))
TEMPLATE_PATH="${TOOLS_PATH}/templates"

source ${TOOLS_PATH}/scripts/shared/color.inc.sh

pause () {
    read -s -p "Press Enter to resume setup... "
}