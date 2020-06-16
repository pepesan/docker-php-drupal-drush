FROM php:7.3-apache

label MAINTAINER="mail@fabdelgado.com"

RUN apt-get update

# 1. Install packages
RUN apt-get install -y \
    git \
    zip \
    curl \
    cron \
    unzip \
    libzip-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    ffmpeg \
    g++

# 2. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin
RUN a2enmod rewrite headers

RUN docker-php-ext-install \
    bcmath \
    mysqli  \
    opcache  \
    mbstring   \
    pdo_mysql   \
    zip \
    gd


# 3. Install imagick 
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions imagick

# 4. Set PHP defaults
RUN { \
        echo 'memory_limit=512M'; \
        echo 'upload_max_filesize=512M'; \
        echo 'post_max_size=512M'; \
        echo 'max_execution_time=120'; \
        echo 'allow_url_fopen=on'; \
        echo 'file_uploads=on'; \
        echo 'date.timezone=America/Montevideo'; \
    } > /usr/local/etc/php/conf.d/uploads.ini

# 5. Set Apache config
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


# 6. Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=. --filename=composer
RUN mv composer /usr/local/bin/

# 7. Install NPM
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN npm install


# 8. Install Drupal
ARG DRUPAL_VERSION

RUN set -eux; \
    curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz; \
    tar -xz --strip-components=1 -f drupal.tar.gz; \
    rm drupal.tar.gz; \
    chown -R www-data:www-data sites modules themes