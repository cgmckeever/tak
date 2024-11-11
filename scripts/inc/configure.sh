#!/bin/bash


letsencrypt (){
	if [ "$LETSENCRYPT" = "true" ];then
		msg $info "\nProcessing LetsEncrypt\n"
		if [[ ! ${TAK_URI} =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ && ${TAK_URI} =~ \. ]];then
			if [ ! -d "/etc/letsencrypt/live/${TAK_URI}" ];then 
				msg $info "Requesting LetsEncrypt\n\n"
	        	${SCRIPT_PATH}/letsencrypt-request.sh ${TAK_ALIAS}
	    	else
	    		msg $success "Found existing LetsEncrypt cert bundle\n"
	    	fi 
		else
			msg $danger "\nLetsEncrypt Error"
			msg $warn "${TAK_URI} does not appear to be a FQDN for LetsEncrypt\n\n"
			exit
		fi
  fi
}

coreconfig (){
    ## Check for specific Version config template
    #
    CONFIG_TMPL="${ROOT_PATH}/tak-conf/coreconfig/CoreConfig.${VERSION}.xml.tmpl"
    if [ ! -f "${CONFIG_TMPL}" ];then
        CONFIG_TMPL="${ROOT_PATH}/tak-conf/coreconfig/CoreConfig.xml.tmpl"
    fi

    mkdir -p ${TAK_PATH}
    
    ACTIVE_SSL=__SELF_SIGNED
    if [ -f "${TAK_PATH}/certs/files/letsencrypt.jks" ];then 
        ACTIVE_SSL=__LE_SIGNED
    fi

    msg $info "\nSyncing CoreConfig: ${TAK_PATH}/CoreConfig.xml"

    sed -e "/<!-- ${ACTIVE_SSL}/d" \
        -e "/${ACTIVE_SSL} -->/d" \
        -e "s/__CA_PASS/${CA_PASS}/g" \
        -e "s/__CLIENT_VALID_DAYS/${CLIENT_VALID_DAYS}/g" \
        -e "s/__ORGANIZATIONAL_UNIT/${ORGANIZATIONAL_UNIT}/g" \
        -e "s/__ORGANIZATION/${ORGANIZATION}/g" \
        -e "s/__TAK_CA/${TAK_CA_FILE}/g" \
        -e "s/__TRUSTSTORE/${TAK_CA_FILE}/g" \
        -e "s/__CA_CRL/${TAK_CA_FILE}/g" \
        -e "s/__TAK_DB_ALIAS/${TAK_DB_ALIAS}/g" \
        -e "s/__TAK_DB_PASS/${TAK_DB_PASS}/g" \
        -e "s/__TAK_URI/${TAK_URI}/g" \
        -e "s/__TAK_COT_PORT/${TAK_COT_PORT}/g" \
        ${CONFIG_TMPL} > ${TAK_PATH}/CoreConfig.xml
}

filesync (){
    mkdir -p ${TAK_PATH}/tak-tools/conf

    cp ${ROOT_PATH}/tak-scripts/* ${TAK_PATH}/tak-tools/
    cp ${ROOT_PATH}/tak-conf/*client* ${TAK_PATH}/tak-tools/conf
    cp ${ROOT_PATH}/tak-conf/cert-metadata.sh ${TAK_PATH}/certs/
    
    cp ${ROOT_PATH}/tak-conf/setenv.sh ${TAK_PATH}/

    cp ${SCRIPT_PATH}/inc/functions.sh ${TAK_PATH}/tak-tools/
    cp ${RELEASE_PATH}/config.inc.sh ${TAK_PATH}/tak-tools/

    mkdir -p jdk/bin
}