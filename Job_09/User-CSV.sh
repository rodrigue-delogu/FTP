#!/bin/bash

#Commande nécessaire à l'installation 
apt install sudo adduser

sudo echo "/bin/false" >> /etc/shells

#Var du fichier CSV
while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
do
  	echo "Prenom:$rec_column1"
  	echo "Nom: $rec_column2"
  	echo "Mdp: $rec_column3"
  	echo "Role: $rec_column4"

#Créa user 
	sudo adduser ${rec_column1,,} --gecos "$rec_column1 $rec_column2 ,,," --disabled-password
    sudo adduser ${rec_column1,,} --shell /bin/false --home /home/{rec_column1,,}
	echo "${rec_column1,,}:$rec_column3" | sudo chpasswd

#Groupe Admin 	
	if [ "$rec_column4" = "Admin" ]; then
	sudo adduser ${rec_column1,,} sudo
fi
#FTPgroup
    if [ "$rec_column4" = "ftpgroup" ]; then
	sudo adduser ${rec_column1,,} ftpgroup
fi
 
done < <(cut -d "," -f2,3,4,5 Shell_Userlist.csv | tail -n +2 )

#Autorisation de ftpgroup et sudo
echo -i "<Limit ALL>\n DenyGroup !ftpgroup\n DenyGroup !sudo</Limit>\n" | sudo tee -a /etc/proftpd/proftpd.conf