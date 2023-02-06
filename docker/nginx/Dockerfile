FROM nginx:alpine
#
ARG APP_ENV=prod

RUN apk update

COPY ./docker/nginx/snippets/ /etc/nginx/snippets
COPY ./docker/nginx/conf.d/mySite.${APP_ENV}.conf /etc/nginx/conf.d/default.conf

COPY ./public /app/public/

WORKDIR /app


