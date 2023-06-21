# honeynetproject
Token
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
![D213 Honeynet](doc/bannerrepo.png)
# D213 Honeynet
## Repositori Instalasi Honeypot

Honeynet D213 merupakan sekumpulan sistem honeypot yang dikonfigurasi bersama membentuk sustu sistem yang disebut honeynet. Honeypot sendiri merupakan sistem yang dirancang sedemikian rupa sehingga dapat diretas oleh penyerang. Honeypot dapat digunakan untuk berbagai tujuan, tetapi salah satu tujuan utamanya adalah mengelabui penyerang dan mempelajari metode atau tools yang mereka gunakan.

## Fitur

- Honeynet berbasis docker dengan kemudahan instalasi dan perbaikan
- Terdiri dari 3 jenis honeypot: Cowrie, Dionaea, Glastopf
- Dapat dipasang diberbagai sistem operasi dan versi Linux

Honeynet ini dikembangkan oleh D213 [BSSN][bssn]

Repository Docker Hub Honeynet D213 [Cowrie][dockerhubrepocow], [Dionaea][dockerhubrepodio], [Glastopf][dockerhubrepoglast]


## Teknologi

Komponen yang digunakan dalam Honeynet D213:

- [Docker] - Aplikasi untuk menyatukan berbagai file software dan pendukungnya dalam sebuah wadah (container).
- [Cowrie] - Medium interaction honeypot berbasis Python yang mengemulasikan SSH dan Telnet.
- [Dionaea] - Low interaction honeypot yang mengemulasikan berbagai jenis layanan seperti FTP, HTTP, Telnet, MSSQL, MySQL, SIP, SMB.
- [Glastopf] - Low interaction honeypot yang mengemulasikan kerentanan web server

## Requirement
Kebutuhan dan spesifikasi sitem untuk menginstal honeynet BSSN dapat dilihat pada tabel berikut

| Spesifikasi | Keterangan |
| ------ | ------ |
| Sistem Operasi | Linux (Debian, Ubuntu 18, 20, 21, 22) |
| Processor | 2 Core |
| RAM | 4 GB |
| Kapasitas Penyimpanan | 128 GB |
| IP Publik | 1 |
| Akses SSH | Port default atau khusus |

## Instalasi

Langkah instalasi berikut akan langsung memasang kebutuhan software, dependencies, serta konfigurasi secara otomatis. Panduan instalasi lengkap dapat dilihat pada dokumen berikut [Panduan Instalasi Honeynet D213](doc/DraftPanduanInstalasiHoneynetD213.pdf)

Lakukan SSH pada server mitra/stakeholder

```sh
ssh xxxxx@103.143.XXX.XXX -pXXXXX
```

Atur waktu dan tanggal dengan mengecek waktu dan tanggal sistem dan menyesuaikan dengan timezone yang akan digunakan sesuai lokasi mitra

```sh
timedatectl
timedatectl list-timezones
sudo timedatectl set-timezone Asia/XXXXX
```

Update repo pada host server mitra

```sh
sudo apt-get update
```

Berikutnya lakukan instalasi Git untuk melakukan clone repository dari Github

```sh
sudo apt-get install -y git
```

Lakukan clone repository Honeynet D213 dari Github

```sh
git clone https://github.com/d213honeynet/honeynet
```
Masukkan username dan Personal Access Token (password)

```sh
d213honeynet
```

```sh
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
```

Pindah ke direktori honeynet/ dan tambahkan permission untuk eksekusi file install-honeypot.sh

```sh
cd honeynet/
chmod +x install-honeypot.sh
```

Jalankan file install-honeypot.sh untuk menjalankan secara otomatis instalasi Honeynet D213

```sh
./install-honeypot.sh
```

## Menjalankan Honeynet Docker

Ketiga honeypot dapat dijalankan dengan mengeksekusi docker-compose dengan file docker-compose.yml

Jalankan honeynet dengan docker-compose, pastikan letak direktori pada honeypot/

```sh
sudo docker-compose up
```

Setelah dipastikan dapat berjalan dan tidak terdapat error, selanjutnya matikan Honeynet Docker dan lanjutkan melakukan konfigurasi tambahan honeynet docker. Jika telah selesai maka jlankan kembali honeynet docker

```sh
sudo docker-compose down
```

## Konfigurasi Tambahan Honeynet Docker

Konfigurasi ini dilakukan untuk menyesuaikan pengaturan pada masing-masing honeypot. Konfigurasi ini untuk mengatur service yang digunakan pada honeypot. Pastikan sebelum melakukan konfigurasi sudah berganti menjadi user root dengan perintah berikut.

```sh
sudo su
```

### Cowrie
Konfigurasi ini untuk mengatur honeypot Cowrie pada file cowrie.cfg untuk mengirimkan log ke Hpfeeds server

```sh
cd /var/lib/docker/volumes/honeynet_cowrie-etc/_data
cp cowrie.cfg.dist cowrie.cfg
nano cowrie.cfg
```

Ganti beberapa konfigurasi Hpfeeds Cowrie hingga seperti berikut :
```sh
# HPFeeds3
# Python3 implementation of HPFeeds
[output_hpfeeds3]
enabled = true
server = 45.120.244.152
port = 10000
identifier = <namamitra-provinsi-cow>
secret = hpfeeds-bssnihp123
debug=false
```

Ubah default port SSH dari port 22 ke port 22888
```sh
sudo nano /etc/ssh/sshd_config
```
```sh
Include /etc/ssh/sshd_config.d/*.conf

Port 22888
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```
Melakukan restart SSH service
```sh
sudo service ssh restart
sudo netstat -tan
sudo systemctl status ssh
```

Konfigurasi iptables server mitra untuk melakukan forward dari port 22 ke port 2222 Cowrie
```sh
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
sudo iptables -t nat -A PREROUTING -p tcp --dport 23 -j REDIRECT --to-port 2223
```

### Dionaea
Konfigurasi ini untuk mengatur honeypot Dionaea untuk menyesuaikan service dan logging serta mengirimkan log ke Hpfeeds server

```sh
cd /var/lib/docker/volumes/honeynet_dionaea/_data/etc/dionaea
cp ihandlers-available/hpfeeds.yaml ihandlers-enabled/
cd ihandlers-enabled/
chmod 777 hpfeeds.yaml
nano hpfeeds.yaml
```

Ganti beberapa konfigurasi Hpfeeds Dionaea hingga seperti berikut :
```sh
# SPDX-FileCopyrightText: none
# SPDX-License-Identifier: CC0-1.0

- name: hpfeeds
  config:
    # fqdn/ip and port of the hpfeeds broker
    server: "45.120.244.152"
    port: 10000
    ident: "<namamitra-provinsi-dio>"
    secret: "hpfeeds-bssnihp123"
    # dynip_resolve: enable to lookup the sensor ip through a webservice
    # dynip_resolve: "http://hpfriends.honeycloud.net/ip"
    # Try to reconnect after N seconds if disconnected from hpfeeds broker
    # reconnect_timeout: 10.0
```

Konfigurasi service SMB Dionaea pada file smb.yaml berikut

```sh
cd /var/lib/docker/volumes/honeynet_dionaea/_data/etc/dionaea/services-available
nano smb.yaml
```

```sh
 # Additional config
    primary_domain: Development
    oem_domain_name: Development
    server_name: Development-Server
```

Konfigurasi service MSSQL Dionaea pada file mssql.py berikut

```sh
cd /var/lib/docker/volumes/honeynet_dionaea/_data/lib/dionaea/python/dionaea/mssql
nano mssql.py
```
Hapus 2 baris terakhir hingga menjadi seperti berikut.

```sh
    def process(self, PacketType, p, data):
        r = ''

        if PacketType == TDS_TYPES_PRE_LOGIN:
            r = TDS_Prelogin_Response()
            # FIXME: any better way to initialise this?
            r.VersionToken.TokenType = 0x00
            r.VersionToken.Offset = 26
            r.VersionToken.Len = 6
            r.EncryptionToken.TokenType = 0x01
            r.EncryptionToken.Offset = 32
            r.EncryptionToken.Len = 1
            r.InstanceToken.TokenType = 0x02
            r.InstanceToken.Offset = 33
            r.InstanceToken.Len = 1
            r.ThreadIDToken.TokenType = 0x03
            r.ThreadIDToken.Offset = 34
            r.ThreadIDToken.Len = 0
            r.MARSToken.TokenType = 0x04
```

### Glastopf
Konfigurasi ini untuk mengatur honeypot Glastopf pada file glastopf.cfg untuk mengirimkan log ke Hpfeeds server

```sh
cd /var/lib/docker/volumes/honeynet_glastopf/_data
nano glastopf.cfg
```

Ganti beberapa konfigurasi Hpfeeds Glastopf hingga seperti berikut :
```sh
[hpfeed]
enabled = True
host = 45.120.244.152
port = 10000
secret = hpfeeds-bssnihp123
# channels comma separated
chan_events = glastopf.events
chan_files = glastopf.files
ident = <namamitra-provinsi-glast>
```

## Direktori Konfigurasi dan Log

Tabel berikut merupakan letak konfigurasi pada masing masing sensor. Untuk mengecek letak direktori konfigurasi dapat dilakukan dengan perintah berikut

```sh
sudo docker volume ls
sudo docker inspect volume <nama-volume>
```


| Honeypot | Letak Direktori |
| ------ | ------ |
| Cowrie | /var/lib/docker/volumes/honeynet_cowrie-etc/_data/ |
| Dionaea| /var/lib/docker/volumes/honeynet_dionaea/_data |
| Glastopf | /var/lib/docker/volumes/honeynet_glastopf/_data |

Letak direktori log masing-masing honeypot

### Cowrie
```sh
/var/lib/docker/volumes/honeynet_cowrie-var/_data/log/cowrie
```

### Dionaea
```sh
/var/lib/docker/volumes/honeynet_dionaea/_data/var/lib/dionaea
```

### Glastopf
```sh
/var/lib/docker/volumes/honeynet_glastopf/_data/db
```

## Pengujian
Pengujian dilakukan dengan menggunakan tools untuk masing-masing honeypot
### Pengujian Cowrie
Lakukan percobaan login ke server mitra dengan menggunakan username “root” dan password “root” jika dapat masuk dan menunjukkan hasil seperti gambar berikut dapat diartikan bahwa Cowrie sudah berjalan dan berfungsi.
```sh
ssh HOST@IP_ADDRESS -p PORT
```
![Pengujian Cowrie](doc/pengujiancowrie.png)

### Pengujian Dionaea
Pengujian Dionaea dilakukan dengan melihat port yang terbuka (listen port) pada server mitra dengan perintah berikut, jika menunjukkan port Dionaea sudah LISTEN seperti gambar dibawah dapat diartikan Dionaea sudah berfungsi.
```sh
netstat -tulnp
```
![Pengujian Dionaea](doc/pengujiandionaea1.png)

Pengujian juga dapat dilakukan dari machine lain untuk melakukan scanning port menggunakan tool Nmap untuk melihat port yang terbuka untuk koneksi dari luar jaringan. Jika menunjukkan seperti gambar berikut dapat diartikan Cowrie sudah dapat berfungsi.

```sh
nmap IP_ADDRESS -sV -Pn -p 2222,2223,21,22,23,42,53,123,135,443,445,1433,1723,1883,1900,3306,5060,5061,11211,10000,27017,80,8080
```
![Pengujian Dionaea](doc/pengujiandionaea2.png)

### Pengujian Glastopf
Pengujian dilakukan dengan membuka alamat IP server mitra dari browser machine lain seperti berikut. Jika menunjukkan halaman berikut dan berganti-ganti tampilan maka dapat diartikan Glastopf sudah berfungsi.

```sh
http://IP_ADDRESS
```
![Pengujian Glastopf](doc/pengujianglastopf.png)

## Command


```sh
sudo docker rmi -f d213honeynet/dionaea:final && sudo docker rmi -f d213honeynet/cowrie:final && sudo docker rmi -f d213honeynet/glastopf:final
```
```sh
sudo docker volume rm -f honeynet_dionaea && sudo docker volume rm -f honeynet_cowrie-etc && sudo docker volume rm -f honeynet_cowrie-var && sudo docker volume rm -f honeynet_glastopf
```
```sh
sudo docker image rm -f $(sudo docker image ls -q)
```

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [bssn]: <https://github.com/DinoTools/dionaea>
   [dockerhubrepodio]: <https://hub.docker.com/repository/docker/d213honeynet/dionaea>
   [dockerhubrepocow]: <https://hub.docker.com/repository/docker/d213honeynet/cowrie>
   [dockerhubrepoglast]: <https://hub.docker.com/repository/docker/d213honeynet/glastopf>
   [docker]: <https://www.docker.com/>
   [cowrie]: <https://github.com/cowrie/cowrie>
   [dionaea]: <https://github.com/DinoTools/dionaea>
   [glastopf]: <https://github.com/mushorg/glastopf>
