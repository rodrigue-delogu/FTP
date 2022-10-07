#!/bin/bash

#Installation des paquets nécessaires server+ssl+crypto
sudo apt install openssl proftpd*

#Création des utilisateurs Merry et Pippin

	sudo adduser merry --gecos ",,,,," --disabled-password
	echo "merry:kalimac" | sudo chpasswd

	sudo adduser pippin --gecos ",,,,," --disabled-password
	echo "pippin:secondbreakfast" | sudo chpasswd
	
#Installation Anonymous
sed -i "164,203s/.//" /etc/proftpd/proftpd.conf
sed -i "172s/.*/AnonRequirePassword off/" /etc/proftpd/proftpd.conf

#Modification du fichier proftpd.conf
sed -i "11s/.*/UseIPv6 off/" /etc/proftpd/proftpd.conf
sed -i "39s/.*/DefaultRoot ~/" /etc/proftpd/proftpd.conf
sed -i "143s/.//" /etc/proftpd/proftpd.conf

#Création du fichier SSL
mkdir /etc/proftpd/ssl

#Création de la clef 
openssl req -new -x509 -days 365 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem -keyout /etc/proftpd/ssl/proftpd.key.pem

#Droits SSL
sudo chmod -R 750 /etc/proftpd/ssl

#Modification du fichier tls.conf
sed -i "10s/.//" /etc/proftpd/tls.conf
sed -i "11s/.//" /etc/proftpd/tls.conf
sed -i "12s/.//" /etc/proftpd/tls.conf

sed -i "27s/.*/TLSRSACertificateFile \/etc\/proftpd\/ssl\/proftpd.cert.pem/" /etc/proftpd/tls.conf
sed -i "28s/.*/TLSRSACertificateKeyFile \/etc\/proftpd\/ssl\/proftpd.key.pem/" /etc/proftpd/tls.conf

sed -i "41s/.*/TLSOptions AllowClientRenegotiations/" /etc/proftpd/tls.conf
sed -i "45s/.*/TLSVerifyClienT off/" /etc/proftpd/tls.conf
sed -i "49s/.*/TLSRequired on/" /etc/proftpd/tls.conf

sed -i "57s/.*/TLSRenegotiate required off/" /etc/proftpd/tls.conf

#Modification du fichier modules.conf 
sed -i "21s/.*/LoadModule mod_tls.c/" /etc/proftpd/modules.conf

#Restart
sudo service proftpd restart
