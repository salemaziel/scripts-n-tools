#!/bin/bash

sudo apt install gcc g++ make -y

curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -

sudo apt update
sudo apt install -y nodejs

npm config set prefix '~/.npm-global'
source ~/.profile

echo " ** Nodejs installed globally; testing install ** "
npm install -g jshint

echo " ** Updating npm ** "
npm install npm@latest -g
