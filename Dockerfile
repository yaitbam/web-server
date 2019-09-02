FROM php:7.1.20-apache
RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y
# Install tools & libraries
RUN apt-get -y install apt-utils nano wget dialog \
		build-essential git curl libcurl3 libcurl3-dev zip
# Install important libraries
		RUN apt-get -y install --fix-missing apt-utils build-essential git curl libcurl3 libcurl3-dev zip \
			libmcrypt-dev libsqlite3-dev libsqlite3-0 mysql-client zlib1g-dev \
			libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev
# Composer
			RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# PHP Extensions
			RUN pecl install xdebug-2.5.5 \
				&& docker-php-ext-enable xdebug \
				&& docker-php-ext-install mcrypt \
				&& docker-php-ext-install pdo_mysql \
				&& docker-php-ext-install pdo_sqlite \
				&& docker-php-ext-install mysqli \
				&& docker-php-ext-install curl \
				&& docker-php-ext-install tokenizer \
				&& docker-php-ext-install json \
				&& docker-php-ext-install zip \
				&& docker-php-ext-install -j$(nproc) intl \
				&& docker-php-ext-install mbstring \
				&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
				&& docker-php-ext-install -j$(nproc) gd \
				&& pecl install redis \
				&& docker-php-ext-enable redis
				ADD server/php.ini /usr/local/etc/php/php.ini
				ADD https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
				RUN chmod +x /usr/local/bin/mhsendmail
				RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends
				RUN pecl install imagick &&  docker-php-ext-enable imagick
				RUN docker-php-ext-install pdo_mysql
				RUN a2enmod rewrite
