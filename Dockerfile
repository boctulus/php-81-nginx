FROM php:8.1-alpine

# Install system dependencies
RUN apk update and apk add git

# Install PHP modules and clean up
RUN apk add --no-cache $PHPIZE_DEPS \
	imagemagick-dev icu-dev zlib-dev jpeg-dev libpng-dev libzip-dev libgomp; \
    docker-php-ext-configure gd --with-jpeg; \
	docker-php-ext-install intl pcntl gd exif zip; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    apk del $PHPIZE_DEPS; \
    rm -rf /tmp/pear;

# Install other dependencies
RUN apk add --no-cache git curl sqlite nodejs npm

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /www/html

RUN mkdir -p /www/html/public

COPY . /www/html/public/