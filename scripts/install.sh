#!/bin/bash
#
# Author: Sakthi Santhosh
# Created on: 19/11/2023
apt-get update && apt-get upgrade -y
apt-get install -y ca-certificates curl gnupg nginx # XXX

install -m 0755 -d /etc/apt/keyrings
curl -f -s -S -L https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -a -G docker pi

systemctl enable docker && systemctl start docker

rm -r /var/www/html/*
cp -r ./website-static/website/* /var/www/html/

mkdir -p /var/log/nginx/sakthisanthosh.in/nextcloud/
cp ./nginx/debian.conf /etc/nginx/sites-available/default

nginx -T
systemctl reload nginx
