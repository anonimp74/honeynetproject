#!/bin/bash

whiptail --title "Honeynet" --msgbox \
"
 _____                         _    
|  |  |___ ___ ___ _ _ ___ ___| |_  
|     | . |   | -_| | |   | -_|  _| 
|__|__|___|_/_|___|_  |_/_|___|_|   
                  |___|
" 0 0

function display_result() {
  whiptail --title "$1" \
    --msgbox "$result" 0 0
}

function advancedMenu() {
 while true; do
    ADVSEL=$(whiptail --title "Pilihan Menu" --fb --menu "Menu" 0 0 10 \
        "1" "Install Honeypot" \
        "2" "Install Honeypot GUI" \
        "3" "Restart Honeypot" \
        "4" "Stop Honeypot" \
        "5" "Cek Pengiriman Log ke Server" \
        "6" "Cek Daftar Sensor Berjalan, Image & Volume Terpasang" \
        "7" "Cek Status Port" \
        "8" "Masuk Honeypot Cowrie" \
        "9" "Masuk Honeypot Dionaea" \
        "10" "Masuk Honeypot Honeytrap" \
        "11" "Hapus Honeypot" 3>&1 1>&2 2>&3)
    exit_status=$?
    if [ $exit_status == 1 ] ; then
      clear
      exit
    fi
    case $ADVSEL in
        1 )
          TERM=ansi whiptail --title "Install Honeypot" --infobox "Instalasi Honeypot berjalan" 8 78
          ./install-honeypot.sh
        ;;
        2 )
          TERM=ansi whiptail --title "Install Honeypot GUI" --infobox "Instalasi Honeypot berjalan" 8 78
          ./install-honeypot-gui.sh
        ;;
        3 )
          result=$(sudo docker-compose down && sudo docker-compose up -d)
          display_result "Restart Honeypot"
        ;;
        4 )
          result=$(sudo docker-compose down)
          display_result "Stop Honeypot"
        ;;
        5 )
          TERM=ansi whiptail --title "Cek Pengiriman Log ke Server" --infobox "Cek Pengiriman Log ke Server" 8 78
          sudo tcpdump -nnNN -A port 10000
        ;;
        6 )
          result=$(sudo docker ps && sudo docker image ls && sudo docker volume ls)
          display_result "Cek Daftar Sensor Berjalan, Image & Volume Terpasang"
        ;;
        7 )
          result=$(sudo netstat -tulnp && sudo docker exec -it dionaea /bin/bash -c "netstat -atn")
          display_result "Cek Status Port"
        ;;
        8 )
          TERM=ansi whiptail \
            --title "Masuk Honeypot Cowrie" \
            --textbox doc/cowrie.txt 16 78
          sudo docker exec -it cowrie /bin/sh
        ;;
        9 )
          TERM=ansi whiptail \
            --title "Masuk Honeypot Dionaea" \
            --textbox doc/dionaea.txt 16 78
          sudo docker exec -it dionaea /bin/bash
        ;;
        10 )
          TERM=ansi whiptail \
            --title "Masuk Honeypot Honeytrap" \
            --textbox doc/honeytrap.txt 16 78
          sudo docker exec -it honeytrap /bin/sh
        ;;
        11 )
           whiptail --title "Konfirmasi" --yesno "Apakah anda yakin akan menghapus seluruh Honeypot?" 8 78
              if [[ $? -eq 0 ]]; then
                 TERM=ansi whiptail --title "Honeynet BSSN" --infobox "Penghapusan Honeypot" 8 78
                 ./delete-honeypot.sh
                  whiptail --title "Honeynet BSSN" --msgbox "Seluruh Honeypot berhasil dihapus" 8 78
              elif [[ $? -eq 1 ]]; then
                  whiptail --title "Honeynet BSSN" --msgbox "Honeypot batal dihapus." 8 78
              elif [[ $? -eq 255 ]]; then
                  whiptail --title "Honeynet BSSN" --msgbox "Keluar dari proses Hapus Honeypot" 8 78
              fi
        ;;
    esac
  done
}
advancedMenu
