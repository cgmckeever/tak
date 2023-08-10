#!/bin/bash

SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")
source ${SCRIPT_PATH}/shared.inc.sh

# =======================

printf $warning "\n\n------------ Creating TAK Client Certificate ------------ \n\n"

read -p "What is the username: " USERNAME

cd ${CERT_PATH}
./makeCert.sh client ${USERNAME}

USER_PASS=${PAD1}$(pwgen -cvy1 -r ${PASS_OMIT} 25)${PAD2}
java -jar ${TAK_PATH}/utils/UserManager.jar usermod -p "${USER_PASS}" $USERNAME

# Admin Priv
# java -jar ${TAK_PATH}/utils/UserManager.jar certmod -A ${TAK_PATH}/certs/files/${USERNAME}.pem

printf $info "\nCreated Client Certificate ${FILE_PATH}/${USERNAME}.p12\n\n"

printf $warning "TAK needs to restart to enable changes.\n\n"
read -p "Restart TAK [y/n]? " RESTART

if [[ $RESTART =~ ^[Yy]$ ]];then
    sudo systemctl restart takserver
fi
