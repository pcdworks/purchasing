#!/bin/bash

echo Installing binddn record
docker cp ./purchasing-binddn.update ipa:/data/root
docker exec -it ipa ipa-ldap-updater /data/root/purchasing-binddn.update

