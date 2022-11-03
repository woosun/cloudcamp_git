#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
#파이썬 설치
sudo apt -y install python3.9
#깃설치
sudo apt-get -y install git
sudo apt -y install git
alias python=python3
alias pip=pip3
#깃으로 클론떠오기
git clone https://github.com/woosun/backend.git
cd ./backend/
pip install -r /requirements.txt
gunicorn --bind 0.0.0.0:8000 wsgi:app