#!/bin/bash
eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d "\r" | ssh-add -
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan gitlab.com > ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts
git config --global user.email "$GIT_MAIL_ADDRESS"
git config --global user.name "fernvenue"
git clone git@gitlab.com:fernvenue/telegram-cidr-list.git
cd "./telegram-cidr-list"
curl "https://core.telegram.org/resources/cidr.txt" > ./CIDR.txt
sed -i "s/[[:space:]]//g" ./CIDR.txt
cp ./CIDR.txt ./CIDR.yaml
sed -i "s|^|- '&|g" ./CIDR.yaml
sed -i "s|$|&'|g" ./CIDR.yaml
sed -i "1s|^|payload:\n|" ./CIDR.yaml
cp ./CIDR.txt ./CIDR.conf
sed -i "s|^|IP-CIDR,|g" ./CIDR.conf
cat ./CIDR.txt | grep -v ":" > ./CIDRv4.txt
cat ./CIDR.conf | grep -v ":" > ./CIDRv4.conf
cat ./CIDR.yaml | grep -v ":" | sed "1s|^|payload:\n|" > ./CIDRv4.yaml
cat ./CIDR.txt | grep ":" > ./CIDRv6.txt
cat ./CIDR.conf | grep ":" > ./CIDRv6.conf
cat ./CIDR.yaml | grep ":" > ./CIDRv6.yaml
updated=`date --rfc-3339 sec`
git init
git add .
git commit -m "$updated"
git push -u origin master
