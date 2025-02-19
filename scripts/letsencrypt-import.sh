#!/bin/bash

SCRIPT_PATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
source ${SCRIPT_PATH}/inc/functions.sh

conf ${1}

cd ${RELEASE_PATH}/tak/certs

msg $warn "\nImporting Lets Encrypt requires \`sudo\` access: \n"

sudo cp /etc/letsencrypt/live/${TAK_URI}/fullchain.pem files/letsencrypt.pem
sudo cp /etc/letsencrypt/live/${TAK_URI}/privkey.pem files/letsencrypt.key.pem
sudo chown $(whoami) files/letsencrypt*

msg $info "\nImporting LetsEncrypt Certificate"

export PATH=${ROOT_PATH}/jdk/bin:${PATH}

openssl pkcs12 -export \
    -in files/letsencrypt.pem \
    -inkey files/letsencrypt.key.pem \
    -name letsencrypt \
    -out files/letsencrypt.p12 \
    -passout pass:${CA_PASS}

keytool -importkeystore \
    -srckeystore files/letsencrypt.p12 \
    -srcstorepass ${CA_PASS} \
    -destkeystore files/letsencrypt.jks \
    -deststorepass ${CA_PASS} \
    -srcstoretype PKCS12

keytool -import \
    -noprompt \
    -alias lebundle \
    -trustcacerts \
    -file files/letsencrypt.pem  \
    -srcstorepass ${CA_PASS} \
    -keystore files/letsencrypt.jks \
    -deststorepass ${CA_PASS} 

msg $info "\nAdding LetsEncrypt Root to Bundled Truststore"
curl -o files/letsencrypt-root.pem https://letsencrypt.org/certs/isrgrootx1.pem
# curl -o files/letsencrypt-intermediate.pem https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem

keytool -import \
    -noprompt \
    -alias letsencrypt-root \
    -file files/letsencrypt-root.pem \
    -keystore files/truststore-${TAK_CA_FILE}-bundle.p12 \
    -storetype PKCS12 \
    -storepass ${CA_PASS}

chmod 644 files/letsencrypt.*