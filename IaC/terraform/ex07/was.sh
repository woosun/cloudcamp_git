#! /bin/bash
export DB_USER=admin
export MYSQL_ROOT_PASSWORD=qwer1234
export DB_DBNAME=yoskr_db
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt -y install python3.9 python3.9-distutils
sudo curl https://bootstrap.pypa.io/get-pip.py -o /apps/get-pip.py
sudo python3.9 /apps/git-pip.py
sudo apt -y install git
git clone https://github.com/woosun/backend.git
cd ./backend/
pip3 install -r ./requirements.txt