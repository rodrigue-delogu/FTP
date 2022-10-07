#!/bin/bash

#Arrêt des serveurs proftpd
sudo service proftpd stop

#Supression du serveur
sudo apt-get --purge remove proftpd* openssl

#Del user 
deluser merry --remove-home
deluser pippin --remove-home