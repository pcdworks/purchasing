#!/bin/bash

PASS=$(pwgen 22 1)
echo -n "Enter your domain: "
read YOUR_DOMAIN
set -f
YDB=(${YOUR_DOMAIN//./ })
YOUR_DOMAIN_BINDDN=""
for i in "${!YDB[@]}"
do
    YOUR_DOMAIN_BINDDN="${YOUR_DOMAIN_BINDDN},dc=${YDB[i]}"
done
sed s/YOUR_PASSWORD/$PASS/g example-binddn.update |\
sed s/YOUR_DOMAIN_BINDDN/$YOUR_DOMAIN_BINDDN/g > purchasing-binddn.update

