#!/bin/bash

NOW=$(date "+%Y.%m.%d-%H.%M.%S")

USER_PASS_OMIT="\"\`'\\"
DB_PASS_OMIT="|%&+$,.~<>/\:;=?{}()^*[]'\`\""

DOCKER_COMPOSE="docker-compose"
if [[ ! $(command -v docker-compose) ]];then
    DOCKER_COMPOSE="docker compose"
fi

case "$(uname)" in
    "Linux")
        OS="linux"
        DEFAULT_NIC=$(ip route | grep '^default' | awk '{print $5}')
        IP_ADDRESS=$(ip addr show "${DEFAULT_NIC}" | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
        ;;
    "Darwin")
        OS="macosx"
        HOSTNAME=$(hostname)
        DEFAULT_NIC=$(route get default | grep 'interface:' | awk '{print $2}')
        IP_ADDRESS=$(ifconfig "${DEFAULT_NIC}" | grep 'inet ' | awk '{print $2}')
        ;;
    *)
        echo "Unsupported OS: $(uname)"
        exit 1
        ;;
esac

info () {
    TAK_INFO=${1}/info.txt
    if [ "${3}" = "init" ]; then
        : > ${TAK_INFO}
    fi

    echo "${2}" >> ${TAK_INFO}
}

msg () {
    printf "${1}" "${2}\n"
}

detail (){
    msg $success "${1}"
    info ${RELEASE_PATH} "${1}"
}

passgen () {
    PADS="abcdefghijklmnopqrstuvwxyz"
    PAD1=${PADS:$(( RANDOM % ${#PADS} )) : 1}
    PAD2=${PADS:$(( RANDOM % ${#PADS} )) : 1}

    PASSGEN=${PAD1}$(pwgen -cvy1 -r ${1} 25)${PAD2}
}

gen_uuid() {
    OPTION=""
    if [ "$OS" = "linux" ]; then
        OPTION="-r"
    fi
    UUID=$(uuidgen ${OPTION})
}

prompt () {
    echo;
    read -p "${1} " ${2}
    #echo -n ${1}
    #read -r ${2}
}

color() {
    STARTCOLOR="\e[$2";
    ENDCOLOR="\e[0m";
    export "$1"="$STARTCOLOR%b$ENDCOLOR"
}
color info 96m      # cyan
color success 92m   # green
color warn 93m      # yellow
color danger 91m    # red

pause () {
    echo
    if [[ ! -z $1 ]]; then
        msg $info "\nThis is a break pause; should be removed: $1\n\n"
    fi
    read -s -p "Press Enter to resume setup... "
    echo
}

rename_files() {
    find "${3}" -type f -name "*${1}*" | while read FILE; do
        NEW_FILE=$(echo "${FILE}" | sed "s/${1}/${2}/g")

        mv ${FILE} ${NEW_FILE}

        echo "Renamed: $(basename ${FILE}) -> $(basename ${NEW_FILE})"
    done
}