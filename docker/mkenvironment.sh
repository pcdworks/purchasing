#!/bin/bash

echo "Generating secret key base"
YOUR_SECRET_KEY_BASE=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 128 ; echo '')

echo "Generating device secret"
YOUR_DEVISE_SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 128 ; echo '')

echo "Generating database password"
YOUR_DB_PASSWORD=$(pwgen 22 1)

echo -n "Enter your email username: "
read YOUR_MAILER_USER_NAME

echo -n "Enter your email Password: "
read YOUR_MAILER_PASSWORD

echo -n "Enter your email port: "
read YOUR_MAILER_PORT

echo -n "Enter your email hostname: "
read YOUR_MAILER_ADDRESS

echo -n "Enter your hostname: "
read YOUR_MAILER_HOSTNAME

echo -n "Enter your domain: "
read YOUR_DOMAIN

set -f
YDB=(${YOUR_DOMAIN//./ })
YOUR_DOMAIN_BINDDN=""
for i in "${!YDB[@]}"
do
    YOUR_DOMAIN_BINDDN="${YOUR_DOMAIN_BINDDN},dc=${YDB[i]}"
done

YOUR_LDAP_PASS=$(cat purchasing-binddn.update | grep add:userPassword: | cut -d ":" -f3)

sed s/YOUR_DB_PASSWORD/$YOUR_DB_PASSWORD/g example.env |\
sed s/YOUR_MAILER_USER_NAME/$YOUR_MAILER_USER_NAME/g |\
sed s/YOUR_MAILER_PASSWORD/$YOUR_MAILER_PASSWORD/g |\
sed s/YOUR_MAILER_PORT/$YOUR_MAILER_PORT/g |\
sed s/YOUR_MAILER_HOSTNAME/$YOUR_MAILER_HOSTNAME/g |\
sed s/YOUR_MAILER_ADDRESS/$YOUR_MAILER_ADDRESS/g |\
sed s/YOUR_DOMAIN/$YOUR_DOMAIN_BINDDN/g |\
sed s/YOUR_LDAP_PASS/$YOUR_LDAP_PASS/g |\
sed s/YOUR_DEVISE_SECRET_KEY/$YOUR_DEVISE_SECRET_KEY/g |\
sed s/YOUR_SECRET_KEY_BASE/$YOUR_SECRET_KEY_BASE/g > variables.env
