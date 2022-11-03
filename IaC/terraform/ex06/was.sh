#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt -y install python3.9 python3.9-distutils
sudo mkdir /apps
sudo curl https://bootstrap.pypa.io/get-pip.py -o /apps/get-pip.py
sudo python3.9 /apps/get-pip.py
sudo apt -y install git
git clone https://github.com/woosun/backend.git
cd ./backend/
sudo pip install -r ./requirements.txt