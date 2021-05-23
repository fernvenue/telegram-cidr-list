#!/bin/bash
eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan github.com > ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts
git config --global user.email "$GITHUB_MAIL_ADDRESS"
git config --global user.name "fernvenue"
git clone git@github.com:fernvenue/telegram-cidr-list.git
cd './telegram-cidr-list'
curl 'https://core.telegram.org/resources/cidr.txt' -o './CIDR.txt'
sed -i 's/[[:space:]]//g' './CIDR.txt'
cp ./CIDR.txt ./CIDR.yaml
sed -i "s|^|  - '&|g" ./CIDR.yaml
sed -i "s|$|&'|g" ./CIDR.yaml
sed -i "1s|^|payload:\n|" ./CIDR.yaml
cp ./CIDR.txt ./CIDR.conf
sed -i "s|^|IP-CIDR,|g" ./CIDR.conf
sed -i "/:/ s/IP-CIDR/IP-CIDR6/" ./CIDR.conf
git init
git add .
git commit -m 'Update CIDR list'
git push -u origin master
