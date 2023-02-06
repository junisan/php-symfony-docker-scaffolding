FROM php:8.2-fpm-alpine

ARG WITH_XDEBUG="false"
ARG PHP_INI_FILE=docker/php/php.prod.ini

ENV APP_ENV=prod

RUN set -eux; \
    apk update; \
    apk add --no-cache \
        git \
    ;\
    \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
#        <If you need extensions, add them here...>
#        libpng \
#        libpng-dev \
#        libjpeg-turbo-dev \
#        libwebp-dev \
#        libzip-dev \
#        libxpm-dev \
    ; \
    \
    docker-php-ext-install \
        mysqli \
        pdo_mysql \
        ctype \
#       <And install here...>
#        gd \
    ; \
    if [ $WITH_XDEBUG == "true" ] ; then \
        apk add --update linux-headers; \
		pecl install xdebug; \
        docker-php-ext-enable xdebug; \
	fi ; \
	\
	runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --virtual .api-phpexts-rundeps $runDeps; \
    \
	apk del .build-deps

COPY ${PHP_INI_FILE} /usr/local/etc/php/conf.d/

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /app

COPY . ./

RUN chmod +x bin/console; sync

COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
CMD ["php-fpm"]
