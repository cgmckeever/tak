#!/bin/bash

printf $warning "\n\n------------ Certificate Generation --------------\n\n"
printf $info "If prompted to replace certificate, enter Y\n"
pause

cd ${CERT_PATH}
mkdir -p files
echo "unique_subject=no" > files/crl_index.txt.attr
while true;do
    printf $info "\n------------ Generating Certificates --------------"
    printf $success "\n\n${TAK_ALIAS}-Root-CA-01\n"
    ./makeRootCa.sh --ca-name $root {TAK_ALIAS}-Root-CA-01
    if [ $? -eq 0 ];then
        printf $success "\n\nca ${TAK_CA}\n"
        ./makeCert.sh ca ${TAK_CA}
        if [ $? -eq 0 ];then
            printf $success "\n\nserver ${TAK_ALIAS}\n"
            ./makeCert.sh server ${TAK_ALIAS}
            if [ $? -eq 0 ];then
                printf $success "\n\nclient ${TAKADMIN}\n"
                ./makeCert.sh client ${TAKADMIN}
                if [ $? -eq 0 ];then
                    break
                fi
            fi
        fi
    fi
    sleep 10
done