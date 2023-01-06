#!/bin/bash

echo "
    __  __                                  __  
   / / / /___  ____  ___  __  ______  ___  / /_ 
  / /_/ / __ \/ __ \/ _ \/ / / / __ \/ _ \/ __/ 
 / __  / /_/ / / / /  __/ /_/ / / / /  __/ /_    
/_/ /_/\____/_/ /_/\___/\__, /_/ /_/\___/\__/  
                       /____/                                                                  
"

PS3='Masukkan Pilihan Anda: '
options=("Install Honeypot"
         "Restart Honeypot"
         "Stop Honeypot"
         "Cek Pengiriman Log ke Server"
         "Cek Daftar Sensor & Volume Terpasang"
         "Cek Status Port"
         "Masuk Honeypot Cowrie"
         "Cek Log Honeypot Cowrie"
         "Masuk Honeypot Dionaea"
         "Cek Log Honeypot Dionaea"
         "Masuk Honeypot Honeytrap"
         "Cek Log Honeypot Honeytrap"
         "Hapus Honeypot"
         "Keluar")

select opt in "${options[@]}"
do
    case $opt in
        "Install Honeypot")
            ./install-honeypot.sh
            ;;
        "Restart Honeypot")
            sudo docker-compose down
            sudo docker-compose up -d
            ;;
        "Stop Honeypot")
            sudo docker-compose down
            ;;
        "Cek Pengiriman Log ke Server")
            sudo tcpdump -nnNN -A port 10000
            ;;
        "Cek Daftar Sensor & Volume Terpasang")
            sudo docker image ls && sudo docker volume ls
            ;;
        "Cek Status Port")
            sudo netstat -tulnp
            sudo docker exec -it dionaea /bin/bash -c "netstat -atn"
            ;;
        "Masuk Honeypot Cowrie")
            sudo docker exec -it cowrie /bin/sh
            ;;
        "Cek Log Honeypot Cowrie")
            echo -e " \n"
            echo "Masukkan perintah berikut untuk masuk direktori Cowrie :"
            echo "File downloaded: cd /var/lib/docker/volumes/honeynet_cowrie-var/_data/lib/cowrie/"
            echo "Log Cowrie: cd /var/lib/docker/volumes/honeynet_cowrie-var/_data/log/cowrie/"
            sudo su
            ;;
        "Masuk Honeypot Dionaea")
            sudo docker exec -it dionaea /bin/bash
            ;;
        "Cek Log Honeypot Dionaea")
            echo -e " \n"
            echo "Masukkan perintah berikut untuk masuk direktori Dionaea :"
            echo "Bistream dan Binaries: cd /var/lib/docker/volumes/honeynet_dionaea/_data/var/lib/dionaea"
            echo "Log Sqlite: cd /var/lib/docker/volumes/honeynet_dionaea/_data/var/log/"
            sudo su
            ;;
        "Masuk Honeypot Honeytrap")
            sudo docker exec -it honeytrap /bin/sh
            ;;
        "Cek Log Honeypot Honeytrap")
            echo -e " \n"
            echo "Masukkan perintah berikut untuk masuk direktori Honeytrap :"
            echo "cd /var/lib/docker/volumes/honeynet_honeytrap/_data/db"
            sudo su
            ;;
        "Hapus Honeypot")
            ./delete-honeypot.sh
            ;;
        "Keluar")
            break
            ;;
        *) echo "Pilihan yang Anda masukkan salah $REPLY";;
    esac
done
