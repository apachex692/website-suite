#!/bin/sh
#
# Author: Sakthi Santhosh
# Created on: 24/09/2023
docker run --name nginx-proxy --network host --publish 81:80 --publish 444:443 --restart unless-stopped --volume /etc/nginx/ssl/:/etc/nginx/ssl/ $1
