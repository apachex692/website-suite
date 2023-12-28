# Author: Sakthi Santhosh
# Created on: 16/09/2023
FROM nginx:alpine-slim

ARG NGINX_SERVER_NAME=sakthisanthosh.in

RUN mkdir /var/log/nginx/${NGINX_SERVER_NAME}/ && \
    mkdir /etc/nginx/ssl/ && \
    touch /var/log/nginx/${NGINX_SERVER_NAME}/access.log /var/log/nginx/${NGINX_SERVER_NAME}/error.log

RUN mkdir /var/log/nginx/${NGINX_SERVER_NAME}/nextcloud/ && \
    mkdir /etc/nginx/ssl/nextcloud/ && \
    touch /var/log/nginx/${NGINX_SERVER_NAME}/nextcloud/access.log /var/log/nginx/${NGINX_SERVER_NAME}/nextcloud/error.log

COPY ./website/ /usr/share/nginx/html/
COPY ./nginx/alpine.conf /etc/nginx/conf.d/default.conf

VOLUME ["/etc/nginx/ssl/"]
