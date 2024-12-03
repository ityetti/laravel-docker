FROM arm64v8/php:8.3-fpm as php

ARG LARAVEL_ROOT=/home/laravel

ENV PHP_MEMORY_LIMIT 4G
ENV PHP_VALIDATE_TIMESTAMPS 1
ENV DEBUG false
ENV UPLOAD_MAX_FILESIZE 64M
ENV PHPRC ${LARAVEL_ROOT}/php.ini
ENV PHP_EXTENSIONS zip pdo pdo_mysql gd mysql

# Install dependencies
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  zip \
  libzip-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  nodejs \
  npm \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

# Install Mailpit
RUN bash -c "$(curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh)"
RUN echo "sendmail_path = /usr/local/bin/mailpit sendmail -S mailpit:1025" >> /usr/local/etc/php/conf.d/sendmail.ini

RUN docker-php-ext-configure \
  opcache --enable-opcache

# Install latest NPM
RUN curl -s -L npmjs.org/install.sh | sh

# Install Yarn
RUN npm i -g yarn

# Install Composer
RUN apt-get update
RUN apt-get install -y wget
RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN chmod +x /usr/local/bin/composer

COPY etc/php-fpm.ini /usr/local/etc/php/conf.d/laravel.ini
COPY etc/php-pcov.ini /usr/local/etc/php/conf.d/pcov-settings.ini
COPY etc/php-fpm.conf /usr/local/etc/

RUN groupadd -g 2000 laravel && useradd -g 2000 -u 2000 -d ${LARAVEL_ROOT} -s /bin/bash laravel

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]

RUN mkdir -p ${LARAVEL_ROOT}

VOLUME ${LARAVEL_ROOT}

RUN chown -R laravel:laravel /usr/local /var/www /var/log /usr/local/etc/php/conf.d ${LARAVEL_ROOT}

ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR ${LARAVEL_ROOT}

USER root

CMD ["php-fpm", "-R"]
