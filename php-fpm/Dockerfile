FROM arm64v8/php:8.2-fpm as php

ARG LARAVEL_ROOT=/home/laravel

# Environment variables for PHP and Laravel
ENV PHP_MEMORY_LIMIT=4G
ENV PHP_VALIDATE_TIMESTAMPS=1
ENV DEBUG=false
ENV UPLOAD_MAX_FILESIZE=64M
ENV PHPRC=${LARAVEL_ROOT}/php.ini
ENV PHP_EXTENSIONS="zip pdo_mysql gd"
# Update the package list and install system dependencies

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    zip \
    unzip \
    git \
    curl \
    wget \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config \
    nodejs \
    npm \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configure GD extension with JPEG and FreeType support
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) $PHP_EXTENSIONS

# Install Mailpit
RUN bash -c "$(curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh)"
RUN echo "sendmail_path = /usr/local/bin/mailpit sendmail -S mailpit:1025" >> /usr/local/etc/php/conf.d/sendmail.ini

# Enable and configure Opcache
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-enable opcache

# Install the latest version of NPM
RUN curl -s -L https://www.npmjs.com/install.sh | sh

# Install Yarn globally
RUN npm install -g yarn

# Install Composer
RUN wget -O composer-setup.php https://getcomposer.org/installer \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# Copy custom PHP configuration files
COPY etc/php-fpm.ini /usr/local/etc/php/conf.d/laravel.ini
COPY etc/php-pcov.ini /usr/local/etc/php/conf.d/pcov-settings.ini
COPY etc/php-fpm.conf /usr/local/etc/

# Add Laravel user and group
RUN groupadd -g 2000 laravel && useradd -g 2000 -u 2000 -d ${LARAVEL_ROOT} -s /bin/bash laravel

# Docker entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]

# Create Laravel root directory and set permissions
RUN mkdir -p ${LARAVEL_ROOT} \
    && chown -R laravel:laravel /usr/local /var/www /var/log /usr/local/etc/php/conf.d ${LARAVEL_ROOT}

# Set working directory
WORKDIR ${LARAVEL_ROOT}

# Running as root
USER root

# Run command
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm", "-R"]