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

exec "$@"
