#!/bin/bash

[ "$DEBUG" = "false" ] && set -x

PHP_EXT_DIR=/usr/local/etc/php/conf.d
PHP_EXT_COM_ON=docker-php-ext-enable

# Clean up old configurations
[ -d ${PHP_EXT_DIR} ] && rm -f ${PHP_EXT_DIR}/docker-php-ext-*.ini

# Enable extensions
if [ -x "$(command -v ${PHP_EXT_COM_ON})" ] && [ ! -z "${PHP_EXTENSIONS}" ]; then
  for ext in ${PHP_EXTENSIONS}; do
    if [ -f "$(php-config --extension-dir)/${ext}.so" ]; then
      ${PHP_EXT_COM_ON} ${ext}
    else
      echo "Extensions ${ext} not found, skip."
    fi
  done
fi

# Set host.docker.internal if not available
HOST_NAME="host.docker.internal"
HOST_IP=$(php -r "putenv('RES_OPTIONS=retrans:1 retry:1 timeout:1 attempts:1'); echo gethostbyname('$HOST_NAME');")
if [[ "$HOST_IP" == "$HOST_NAME" ]]; then
  HOST_IP=$(/sbin/ip route|awk '/default/ { print $3 }')
  printf "\n%s %s\n" "$HOST_IP" "$HOST_NAME" >> /etc/hosts
fi

exec "$@"
