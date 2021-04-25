#!/bin/bash

set -e 
echo "Starting up"
SERVER_NAME=seafile
if [ -z $PROTOCOL ]; then
    PROTOCOL=http
fi

if [ -z $DOMAIN ]; then 
    SERVER_IP=0.0.0.0
    DOMAIN=$PROTOCOL://$SERVER_IP
else
    SERVER_IP=$DOMAIN
fi
SEAFILE_PORT=8082
SEAHUB_PORT=8000

function seafile_server() {
  echo "$1 server"
  $TOPDIR/shared/seafile.sh $1
  $TOPDIR/shared/seahub.sh $1
}

function update_link() {
    WEB_URL=$1
    SEAHUB_SETTING_PY=$TOPDIR/shared/conf/seahub_settings.py
    CCNET_CONF=$TOPDIR/shared/conf/ccnet.conf
    
    if [ -z "$(grep 'FILE_SERVER_ROOT' $SEAHUB_SETTING_PY)" ]; then
        echo "FILE_SERVER_ROOT = '$WEB_URL/seafhttp'" >> $SEAHUB_SETTING_PY
    else
        sed -i "s|FILE_SERVER_ROOT.*|FILE_SERVER_ROOT = '$WEB_URL/seafhttp'|g" $SEAHUB_SETTING_PY
    fi
    
    if [ -z "$(grep 'CSRF_TRUSTED_ORIGINS' $SEAHUB_SETTING_PY)" ]; then    
        echo "CSRF_TRUSTED_ORIGINS = ['${DOMAIN}:${PORT}']" >> $SEAHUB_SETTING_PY
    else
        sed -i "s|CSRF_TRUSTED_ORIGINS.*|CSRF_TRUSTED_ORIGINS = ['${DOMAIN}:${PORT}']|g" $SEAHUB_SETTING_PY
    fi

    sed -i "s:SERVICE_URL.*:SERVICE_URL = $URL:g" $CCNET_CONF
}

## Seafile
if [[ -L $TOPDIR/shared/seahub/media/avatars ]]; then
    rm -rf $TOPDIR/seafile-server-latest/seahub/media/avatars
fi
cp $TOPDIR/seafile-server-latest/* $TOPDIR/shared/ -rf
set +e
$TOPDIR/shared/setup-seafile.sh auto -n $SERVER_NAME -i $SERVER_IP -p $SEAFILE_PORT -d $TOPDIR/shared/
set -e
#update_link $DOMAIN
INSTALLPATH=$(dirname "${SCRIPT}")
seafile_server start

## Nginx
rm -rf /etc/nginx/sites-enabled/*
if [ "$PROTOCOL" == "http" ]; then
    ln -s /etc/nginx/sites-available/seafile.conf /etc/nginx/sites-enabled/seafile.conf
fi
if [ "$PROTOCOL" == "https" ]; then
    sed -i "s/__PORT__/$PORT/g" /etc/nginx/sites-available/seafile-ssl.conf
    ln -s /etc/nginx/sites-available/seafile-ssl.conf /etc/nginx/sites-enabled/seafile-ssl.conf
fi
/usr/sbin/nginx

echo "server is listening at $DOMAIN"
# a hack to keep the script running
while true; do sleep 1000; done
