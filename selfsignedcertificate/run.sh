#!/usr/bin/env bashio
set -e

bashio::log.info "Starting the Self Signed Certificate add-on"

KEYFILE=$(bashio::config 'keyfile')
KEYFILE_PATH="/ssl/${KEYFILE}"

CERTFILE=$(bashio::config 'certfile')
CERTFILE_PATH="/ssl/${CERTFILE}"

VALIDITY=$(bashio::config 'validity')
DOMAIN=$(bashio::config 'domain')
ORGANIZATION=$(bashio::config 'organization')
STREET=$(bashio::config 'street')
CITY=$(bashio::config 'city')
COUNTRY=$(bashio::config 'country')

# Remove older certificate
if [ ! -d "$CERTFILE_PATH" ]; then
    bashio::log.info "Removing previously created certificate & key"
    rm -f $CERTFILE_PATH
    rm -f $KEYFILE_PATH
else
    bashio::log.info "No previously created certificate found"
fi

# Generate new cert
bashio::log.info "Generating the new certificate for ${DOMAIN}"
openssl req -new -newkey rsa:4096 -days ${VALIDITY} -sha256 -nodes -x509 \
    -subj "/C=${COUNTRY}/ST=${STREET}/L=${CITY}/O=${ORGANIZATION}/CN=${DOMAIN}" \
    -keyout $KEYFILE_PATH -out $CERTFILE_PATH \
    -addext "subjectAltName = DNS:${DOMAIN}"

bashio::log.info 'The details of the created SSL certificate:'
openssl x509 -in $CERTFILE_PATH -text -noout

bashio::log.info "Stopping the Self Signed Certificate add-on"