FROM php:8.3-fpm

LABEL Maintainer="Sebastiano"
LABEL Description="PHP 8.3 for Laravel with Xdebug and Composer"

RUN apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && apt-get update

# Zip | Git | Curl | GD | Human Language and Character Encoding Support
RUN apt-get install -y libzip-dev zip git libcurl3-dev curl libfreetype6-dev libjpeg62-turbo-dev libpng-dev zlib1g-dev libicu-dev g++

# mysql | Zip | Curl \ GD | BC Math | Human Language and Character Encoding Support
RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure zip && docker-php-ext-install zip \
    && docker-php-ext-install curl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# opcache extension | PHP Redis extension
RUN docker-php-ext-install opcache \
    && pecl install redis && docker-php-ext-enable redis

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
