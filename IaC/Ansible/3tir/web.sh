#!/bin/bash
sudo apt update -y
sudo apt-get install nginx -y
sudo apt -y install git
git clone https://github.com/woosun/frontend.git
cd ./frontend/
source /tmp/env_was_host
sudo mv ./frontend.conf /etc/nginx/conf.d/default.conf
sudo rm /etc/nginx/sites-enabled/default
sudo sed -i "s/svc-was/$WAS_ADDR/g" /etc/nginx/conf.d/default.conf
sudo sed -i "s/8080/8000/g" /etc/nginx/conf.d/default.conf
sudo mkdir /usr/share/nginx/html/static
sudo mv ./hello.html /usr/share/nginx/html/static/
sudo sed -i "s/svc-was/$WEB_PUB_ADDR/g" /usr/share/nginx/html/static/hello.html