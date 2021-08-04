#!/usr/bin/env bash
mkdir app && cd app

apt update -y
apt upgrade -y

apt install curl -y
curl -sO https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm -rf packages-microsoft-prod.deb

apt update -y
apt upgrade -y
apt install apt-transport-https \
                dotnet-sdk-3.1 \
                systemctl \
                nginx \
                git -y

git clone https://github.com/Olddude/identity.git && cd identity
cp ./identity.service /etc/systemd/system/
systemctl daemon-reload
systemctl start identity.service

cp ./nginx.conf /etc/nginx/sites-available/default

dotnet restore
dotnet build
dotnet publish
