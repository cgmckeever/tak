#!/bin/bash

## Release Name
#
HOSTNAME_DEFAULT=${HOSTNAME//\./-}
prompt "Name your TAK release alias [${HOSTNAME_DEFAULT}] :" TAK_ALIAS
TAK_ALIAS=${TAK_ALIAS:-${HOSTNAME_DEFAULT}}

## TAK URI 
#
prompt "What is the URI (FQDN, hostname, or IP) [${IP_ADDRESS}] :" TAK_URI
TAK_URI=${TAK_URI:-${IP_ADDRESS}}

## DB Password
#
passgen ${DB_PASS_OMIT}
TAK_DB_PASS=${PASSGEN}
#prompt "TAK Database Password: Default [${TAK_DB_PASS}] :" DB_PASS_INPUT
#TAK_DB_PASS=${DB_PASS_INPUT:-${TAK_DB_PASS}}

if [[ "${INSTALLER}" == "docker" ]];then 
	TAK_DB_ALIAS=tak-database
else	
	TAK_DB_ALIAS=127.0.0.1
fi 


## CA Info
#
msg $info "\n\nCertificate Information (you can accept all the defaults)"

ORGANIZATION_DEFAULT="tak-tools"
prompt "Certificate Organization [${ORGANIZATION_DEFAULT}] :" ORGANIZATION
ORGANIZATION=${ORGANIZATION:-${ORGANIZATION_DEFAULT}}

ORGANIZATIONAL_UNIT_DEFAULT="tak"
prompt "Certificate Organizational Unit [${ORGANIZATIONAL_UNIT_DEFAULT}] :" ORGANIZATIONAL_UNIT
ORGANIZATIONAL_UNIT=${ORGANIZATIONAL_UNIT:-${ORGANIZATIONAL_UNIT_DEFAULT}}

CITY_DEFAULT="XX"
prompt "Certificate City [${CITY_DEFAULT}] :" CITY
CITY=$(uppercase "${CITY:-${CITY_DEFAULT}}")

STATE_DEFAULT="XX"
prompt "Certificate State [${STATE_DEFAULT}] :" STATE
STATE=$(uppercase "${STATE:-${STATE_DEFAULT}}")

COUNTRY_DEFAULT="US"
prompt "Certificate Country (two letter abbreviation) [${COUNTRY_DEFAULT}] :" COUNTRY
COUNTRY=$(uppercase "${COUNTRY:-${COUNTRY_DEFAULT}}")

CA_PASS_DEFAULT="atakatak"
prompt "Certificate Authority Password [${CA_PASS_DEFAULT}] :" CA_PASS
CA_PASS=${CA_PASS:-${CA_PASS_DEFAULT}}

CERT_PASS_DEFAULT="atakatak"
prompt "Client Certificate Password [${CERT_PASS_DEFAULT}] :" CERT_PASS
CERT_PASS=${CERT_PASS:-${CERT_PASS_DEFAULT}}

CLIENT_VALID_DAYS_DEFAULT="30"
prompt "Client Certificate Validity Duration (days) [${CLIENT_VALID_DAYS_DEFAULT}] :" CLIENT_VALID_DAYS
CLIENT_VALID_DAYS=${CLIENT_VALID_DAYS:-${CLIENT_VALID_DAYS_DEFAULT}}


## LetsEncrypt (optional)
#
msg $info "\n\nLetsEncrypt"

LE_ENABLE=false
LE_EMAIL=""
LE_VALIDATOR="none"

prompt "Enable LetsEncrypt [y/N] :" LE_PROMPT
if [[ ${LE_PROMPT} =~ ^[Yy]$ ]];then
	LE_ENABLE=true

	prompt "LetsEncrypt Confirmation Email:" LE_EMAIL

	prompt "LetsEncrypt Validator (web/dns):" LE_VALIDATOR
	if [[ "${LE_VALIDATOR}" != "web" && "${LE_VALIDATOR}" != "dns" ]]; then
		LE_VALIDATOR="dns"
	fi
fi

