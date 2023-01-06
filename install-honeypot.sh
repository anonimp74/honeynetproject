#!/bin/bash

echo -e " \n"
echo "+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+
|I|n|s|t|a|l|a|s|i| |H|o|n|e|y|n|e|t| |D|2|1|3|
+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+"

cp config/cowrie/cowrie.cfg.dist config/cowrie/cowrie.cfg
#cp config/dionaea/hpfeeds.yaml.dist config/dionaea/ihandlers/hpfeeds.yaml
#cp config/glastopf/glastopf.cfg.dist config/glastopf/glastopf.cfg


cp restart-docker.sh.dist restart-docker.sh
sed -i "s,LOCAL_PATH,$PWD," restart-docker.sh

LOC=$(pwd)
sudo crontab -l > tmpcron
echo "0 6 */2 * * $LOC/restart-docker.sh" >> tmpcron
sudo crontab tmpcron
rm tmpcron

echo -e " \n"
echo "+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+
|I|n|s|t|a|l|a|s|i| |D|o|c|k|e|r|
+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+"
echo "Instalasi Docker"
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
sudo apt install -y docker-compose

echo -e " \n"
echo "+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+
|I|n|s|t|a|l|a|s|i| |H|o|n|e|y|p|o|t| |C|o|w|r|i|e|
+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+"
echo "instalasi Honeypot Cowrie"
sudo docker pull d213honeynet/cowrie:final

echo -e " \n"
echo "+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+
|I|n|s|t|a|l|a|s|i| |H|o|n|e|y|p|o|t| |D|i|o|n|a|e|a|
+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+"
echo "instalasi Honeypot Dionaea"
sudo docker build -t dionaea/dionaea:latest . --force-rm=true

echo -e " \n"
echo "+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
|I|n|s|t|a|l|a|s|i| |H|o|n|e|y|p|o|t| |H|o|n|e|y|t|r|a|p|
+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+"
echo "instalasi Honeypot Honeytrap"
sudo docker pull honeytrap/honeytrap:latest

echo -e " \n"
echo "Konfigurasi Tambahan"
echo "+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
|K|o|n|f|i|g|u|r|a|s|i| |T|a|m|b|a|h|a|n|
+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+"

sudo docker-compose up -d
sleep 15
sudo docker-compose down

sudo su -c "cp config/cowrie/cowrie.cfg /var/lib/docker/volumes/honeynet_cowrie-etc/_data"
#sudo su -c "cp config/cowrie/cowrie.cfg /var/lib/docker/volumes/honeynet_cowrie-etc/_data; cp config/honeytrap/config.toml /var/lib/docker/volumes/honeynet_honeytrap/_data"

sudo docker-compose up -d

echo -e " \n"
echo "Instalasi Selesai & Honeypot Sudah Berjalan"
echo "+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+ +-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+
|I|n|s|t|a|l|a|s|i| |S|e|l|e|s|a|i| |&| |H|o|n|e|y|p|o|t| |S|u|d|a|h| |B|e|r|j|a|l|a|n|
+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+ +-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+"

exit 0
