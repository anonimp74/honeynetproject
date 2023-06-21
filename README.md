# honeynetproject
![D213 Honeynet](doc/bannerrepo.png)
# D213 Honeynet
## Repositori Instalasi Honeypot

Honeynet D213 merupakan sekumpulan sistem honeypot yang dikonfigurasi bersama membentuk sustu sistem yang disebut honeynet. Honeypot sendiri merupakan sistem yang dirancang sedemikian rupa sehingga dapat diretas oleh penyerang. Honeypot dapat digunakan untuk berbagai tujuan, tetapi salah satu tujuan utamanya adalah mengelabui penyerang dan mempelajari metode atau tools yang mereka gunakan.

## Fitur

- Honeynet berbasis docker dengan kemudahan instalasi dan perbaikan
- Terdiri dari 3 jenis honeypot: Cowrie, Dionaea, Honeytrap
- Dapat dipasang diberbagai sistem operasi dan versi Linux

Honeynet ini dikembangkan oleh D213 [BSSN][bssn]

Repository Docker Hub Honeynet D213 [Cowrie][dockerhubrepocow], [Dionaea][dockerhubrepodio], [Honeytrap][dockerhubrepoglast]


## Teknologi

Komponen yang digunakan dalam Honeynet D213:

- [Docker] - Aplikasi untuk menyatukan berbagai file software dan pendukungnya dalam sebuah wadah (container).
- [Cowrie] - Medium interaction honeypot berbasis Python yang mengemulasikan SSH dan Telnet.
- [Dionaea] - Low interaction honeypot yang mengemulasikan berbagai jenis layanan seperti FTP, HTTP, Telnet, MSSQL, MySQL, SIP, SMB.
- [Honeytrap] - Low interaction honeypot yang mengemulasikan kerentanan SSH server

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

Langkah instalasi berikut akan langsung memasang kebutuhan software, dependencies, serta konfigurasi secara otomatis

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
sudo apt-get install -y git whiptail
```

Lakukan clone repository Honeynet D213 dari Github

```sh
git clone https://github.com/anonimp74/honeynetproject
```
Masukkan username dan Personal Access Token (password)

```sh
anonimp74
```

```sh
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
```

Pindah ke direktori honeynet/ dan tambahkan permission untuk eksekusi file install-honeypot.sh

```sh
cd honeynet/
chmod +x install-honeypot-gui.sh
```

Jalankan file install-honeypot.sh untuk menjalankan secara otomatis instalasi Honeynet D213

```sh
./install-honeypot-gui.sh
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

## Direktori Konfigurasi dan Log

Tabel berikut merupakan letak konfigurasi pada masing masing sensor. Untuk mengecek letak direktori konfigurasi dapat dilakukan dengan perintah berikut

```sh
sudo docker volume ls
sudo docker inspect volume <nama-volume>
```


| Honeypot | Letak Direktori |
| ------ | ------ |
| Cowrie | /var/lib/docker/volumes/honeynetproject_cowrie-etc/_data/ |
| Dionaea| /var/lib/docker/volumes/honeynetproject_dionaea/_data |
| Honeytrap | /var/lib/docker/volumes/honeynetproject_honeytrap/_data |

Letak direktori log masing-masing honeypot

### Cowrie
```sh
/var/lib/docker/volumes/honeynet_cowrie-var/_data/log/cowrie
```

### Dionaea
```sh
/var/lib/docker/volumes/honeynet_dionaea/_data/var/lib/dionaea
```

### Honeytrap
```sh
/var/lib/docker/volumes/honeynetproject_honeytrap/_data/db
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

### Pengujian Honeytrap
Lakukan percobaan login ke server mitra dengan menggunakan username “root” dan password “root” jika dapat masuk dan menunjukkan hasil seperti gambar berikut dapat diartikan bahwa Cowrie sudah berjalan dan berfungsi.
```sh
ssh HOST@IP_ADDRESS -p PORT
```
![Pengujian Cowrie](doc/pengujiancowrie.png)

## Command


```sh
sudo docker rmi -f anonimp74/dionaea:final && sudo docker rmi -f anonimp74/cowrie:final && sudo docker rmi -f anonimp74/Honeytrap:final
```
```sh
sudo docker volume rm -f honeynet_dionaea && sudo docker volume rm -f honeynet_cowrie-etc && sudo docker volume rm -f honeynet_cowrie-var && sudo docker volume rm -f honeynet_Honeytrap
```
```sh
sudo docker image rm -f $(sudo docker image ls -q)
```

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

