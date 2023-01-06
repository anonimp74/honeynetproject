#!/bin/bash

cp config/cowrie/cowrie.cfg.dist config/cowrie/cowrie.cfg
#cp config/dionaea/hpfeeds.yaml.dist config/dionaea/ihandlers/hpfeeds.yaml

cp restart-docker.sh.dist restart-docker.sh
sed -i "s,LOCAL_PATH,$PWD," restart-docker.sh

LOC=$(pwd)
sudo crontab -l > tmpcron
echo "0 6 */2 * * $LOC/restart-docker.sh" >> tmpcron
sudo crontab tmpcron
rm tmpcron


{
	sleep 0.5
	echo -e "XXX\n0\nInstalasi Docker... \nXXX"
    	sleep 2
    	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo apt-get install -y docker-compose
	sudo apt-get install sqlite3
    	echo -e "XXX\n25\nInstalasi Docker... Selesai.\nXXX"
    	sleep 0.5
	
    	echo -e "XXX\n25\nInstalasi Honeypot Cowrie... \nXXX"
   	sleep 2
   	sudo docker pull d213honeynet/cowrie:final
   	echo -e "XXX\n50\nInstalasi Honeypot Cowrie... Selesai.\nXXX"
    	sleep 0.5

    	echo -e "XXX\n50\nInstalasi Honeypot Dionaea... \nXXX"
    	sleep 2
    	sudo docker build -t dionaea/dionaea:latest . --force-rm=true
    	echo -e "XXX\n75\nInstalasi Honeypot Dionaea... Selesai.\nXXX"
    	sleep 0.5
    	
    	echo -e "XXX\n75\nInstalasi Honeypot Honeytrap... \nXXX"
    	sleep 2
    	sudo docker pull honeytrap/honeytrap:latest
    	echo -e "XXX\n100\nInstalasi Honeypot Honeytrap... Selesai.\nXXX"
    	sleep 1
} |whiptail --title "Instalasi Honeypot" --gauge "Tunggu proses instalasi" 6 60 0

TERM=ansi whiptail --title "Konfigurasi Tambahan" --infobox "Melakukan konfigurasi tambahan pada honeypot" 8 78
sudo docker-compose up -d
sleep 15
sudo docker-compose down
sudo su -c "cp config/cowrie/cowrie.cfg /var/lib/docker/volumes/honeynet_cowrie-etc/_data"
#sudo su -c "cp config/cowrie/cowrie.cfg /var/lib/docker/volumes/honeynet_cowrie-etc/_data; cp config/honeytrap/config.toml /var/lib/docker/volumes/honeynet_honeytrap/_data"
sudo docker-compose up -d
whiptail --title "Instalasi Honeypot" --msgbox "Proses Instalasi Honeypot Selesai & Honeypot Sudah Berjalan" 8 78

exit 0
