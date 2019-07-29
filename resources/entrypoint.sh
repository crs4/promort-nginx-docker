#!/usr/bin/env bash

set -e

echo "-- Preparing site configuration file --"
DJANGO_SERVER="${DJANGO_SERVER:-}"
PROTOCOL="${VIRTUAL_PROTO:-http}"

if [ -z $DJANGO_SERVER ]; then
    echo "No DJANGO_SERVER specified, exit!"
    exit 125
fi

if [ $PROTOCOL == "http" ]; then
    echo "Configuring for HTTP protocol"
    envsubst '${DJANGO_SERVER}' < /etc/nginx/conf.d/promort_http.template > /etc/nginx/sites-enabled/promort.conf
elif [ $PROTOCOL == "https" ]; then
    echo "Configuring for HTTPS protocol"
    envsubst '${DJANGO_SERVER},${VIRTUAL_HOST}' < /etc/nginx/conf.d/promort_https.template > /etc/nginx/sites-enabled/promort.conf
else
    echo "${PROTOCOL} is not a valid one"
    exit 125
fi

echo "-- Starting nginx server --"
nginx -g 'daemon off;'
