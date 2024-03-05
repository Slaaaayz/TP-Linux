# TP4 : Real services
## SOMMAIRE 
- [Partie 1 : Partitionnement du serveur de stockage](#partie-1--partitionnement-du-serveur-de-stockage)

- [Partie 2 : Serveur de partage de fichiers](#partie-2--serveur-de-partage-de-fichiers)

- [Partie 3 : Serveur web](#partie-3--serveur-web)
    - [2. Install](#2-install)
    - [3. Analyse](#3-analyse)
    - [4. Visite du service web](#4-visite-du-service-web)
    - [5. Modif de la conf du serveur web](#5-modif-de-la-conf-du-serveur-web)
    - [6. Deux sites web sur un seul serveur](#6-deux-sites-web-sur-un-seul-serveur)
## Partie 1 : Partitionnement du serveur de stockage
**🌞 Partitionner le disque à l'aide de LVM**
- créer un physical volume (PV) 
```bash
[slayz@localhost ~]$ sudo pvcreate /dev/sdb /dev/sdc
  Physical volume "/dev/sdb" successfully created.
  Physical volume "/dev/sdc" successfully created.
```
- créer un nouveau volume group (VG)
```bash
[slayz@localhost ~]$ sudo vgcreate storage /dev/sdb /dev/sdc
  Volume group "storage" successfully created
```
- créer un nouveau logical volume (LV) : ce sera la partition utilisable
```bash
[slayz@localhost ~]$ sudo lvcreate -l 100%FREE -n partition_utilisable storage
  Logical volume "partition_utilisable" created.
```

**🌞 Formater la partition**
```bash
[slayz@localhost ~]$ sudo mkfs.ext4 /dev/storage/partition_utilisable
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 29a1b249-69c5-4f4a-a55b-84e7aac4a28b
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

**🌞 Monter la partition**
```bash
[slayz@localhost ~]$ sudo mkdir /storage
[slayz@localhost ~]$ sudo mount /dev/storage/partition_utilisable /storage
[slayz@localhost ~]$ df -h | grep '/storage'
/dev/mapper/storage-partition_utilisable  3.9G   24K  3.7G   1% /storage
[slayz@localhost ~]$ sudo nano /etc/fstab
/dev/storage/partition_utilisable   /storage   ext4   defaults   0  0
[slayz@localhost ~]$ sudo mount -a
[slayz@localhost ~]$ df -h
Filesystem                                Size  Used Avail Use% Mounted on
devtmpfs                                  4.0M     0  4.0M   0% /dev
tmpfs                                     386M     0  386M   0% /dev/shm
tmpfs                                     155M  3.6M  151M   3% /run
/dev/mapper/rl-root                       6.2G  1.2G  5.1G  20% /
/dev/sda1                                1014M  220M  795M  22% /boot
tmpfs                                      78M     0   78M   0% /run/user/1000
/dev/mapper/storage-partition_utilisable  3.9G   24K  3.7G   1% /storage
```
## Partie 2 : Serveur de partage de fichiers
**🌞 Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**
```bash
[slayz@serveur ~]$ sudo dnf install nfs-utils
[slayz@serveur ~]$ sudo mkdir /storage/site_web_1 -p
[slayz@serveur ~]$ sudo mkdir /storage/site_web_2 -p
[slayz@serveur ~]$ sudo nano /etc/exports
/storage/site_web_1    192.168.56.112(rw,sync,no_root_squash)
/storage/site_web_2    192.168.56.112(rw,sync,no_root_squash)
[slayz@serveur ~]$ sudo systemctl enable nfs-server
[slayz@serveur ~]$ sudo systemctl start nfs-server

[slayz@serveur ~]$ sudo systemctl status nfs-server
[sudo] password for slayz:
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; preset: disabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Mon 2024-02-19 14:00:05
[slayz@serveur ~]$ sudo firewall-cmd --permanent --add-service=nfs
[slayz@serveur ~]$ sudo firewall-cmd --permanent --add-service=mountd
[slayz@serveur ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
[slayz@serveur ~]$ sudo firewall-cmd --reload
[slayz@serveur ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
```

**🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux**
```bash
[slayz@web ~]$ sudo mkdir -p /var/www/site_web_1
[slayz@web ~]$ sudo mkdir -p /var/www/site_web_2
[slayz@web ~]$ sudo mount 192.168.56.111:/storage/site_web_1 /var/www/site_web_1
[slayz@web ~]$ sudo mount 192.168.56.111:/storage/site_web_2 /var/www/site_web_2
[slayz@web ~]$ df -h
Filesystem                          Size  Used Avail Use% Mounted on
devtmpfs                            4.0M     0  4.0M   0% /dev
tmpfs                               386M     0  386M   0% /dev/shm
tmpfs                               155M  3.7M  151M   3% /run
/dev/mapper/rl-root                 6.2G  1.2G  5.0G  20% /
/dev/sda1                          1014M  220M  795M  22% /boot
tmpfs                                78M     0   78M   0% /run/user/1000
192.168.56.111:/storage/site_web_2  3.9G     0  3.7G   0% /var/www/site_web_2
192.168.56.111:/storage/site_web_1  3.9G     0  3.7G   0% /var/www/site_web_1
[slayz@web ~]$ sudo nano /etc/fstab
192.168.56.111:/storage/site_web_1               /var/www/site_web_1   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
192.168.56.111:/storage/site_web_2               /var/www/.site_web_2      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## Partie 3 : Serveur web

### 2. Install
**🌞 Installez NGINX**
```bash
[slayz@web ~]$ sudo dnf install nginx
```
### 3. Analyse
**🌞 Analysez le service NGINX**
- avec une commande ps, déterminer sous quel utilisateur tourne le processus du service NGINX

```bash
[slayz@web ~]$ sudo ps -ef | grep nginx
nginx      12288   12287  0 14:31 ?        00:00:00 nginx: worker process
```
- avec une commande ss, déterminer derrière quel port écoute actuellement le serveur web

```bash
[slayz@web ~]$ ss -alntpu
Netid         State          Recv-Q         Send-Q                   Local Address:Port                   Peer Address:Port         Process
tcp           LISTEN         0              511                            0.0.0.0:80                          0.0.0.0:*
```

- en regardant la conf, déterminer dans quel dossier se trouve la racine web
```bash
[slayz@web ~]$ sudo cat /etc/nginx/nginx.conf | grep html
    # See http://nginx.org/en/docs/ngx_core_module.html#include
        root         /usr/share/nginx/html;
        error_page 404 /404.html;
        location = /404.html {
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
#        root         /usr/share/nginx/html;
#        error_page 404 /404.html;
#            location = /40x.html {
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
```
- inspectez les fichiers de la racine web, et vérifier qu'ils sont bien accessibles en lecture par l'utilisateur qui lance le processus

```bash
[slayz@web ~]$ ll /usr/share/nginx/html/
total 12
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 19 14:26 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```

### 4. Visite du service web
**🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX**
```bash
[slayz@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[slayz@web ~]$ sudo firewall-cmd --reload
success
```
**🌞 Accéder au site web**
```bash
PS C:\Users\melb3> curl 192.168.56.112


StatusCode        : 200
StatusDescription : OK
Content           : <!doctype html>
                    <html>
                      <head>
                        <meta charset='utf-8'>
                        <meta name='viewport' content='width=device-width, initial-scale=1'>
                        <title>HTTP Server Test Page powered by: Rocky Linux</title>
                       ...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 7620
                    Content-Type: text/html
                    Date: Mon, 19 Feb 2024 13:42:27 GMT
                    ETag: "63dc2b1f-1dc4"
                    Last-Modified: Thu, 02 Feb 202...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 7620], [Content-Type,
                    text/html]...}
Images            : {@{innerHTML=; innerText=; outerHTML=<IMG alt="[ Powered by Rocky Linux ]"
                    src="icons/poweredby.png">; outerText=; tagName=IMG; alt=[ Powered by Rocky Linux ];
                    src=icons/poweredby.png}, @{innerHTML=; innerText=; outerHTML=<IMG src="poweredby.png">;
                    outerText=; tagName=IMG; src=poweredby.png}}
InputFields       : {}
Links             : {@{innerHTML=<STRONG>Rocky Linux website</STRONG>; innerText=Rocky Linux website; outerHTML=<A
                    href="https://rockylinux.org/"><STRONG>Rocky Linux website</STRONG></A>; outerText=Rocky Linux
                    website; tagName=A; href=https://rockylinux.org/}, @{innerHTML=Apache Webserver</STRONG>;
                    innerText=Apache Webserver; outerHTML=<A href="https://httpd.apache.org/">Apache
                    Webserver</STRONG></A>; outerText=Apache Webserver; tagName=A; href=https://httpd.apache.org/},
                    @{innerHTML=Nginx</STRONG>; innerText=Nginx; outerHTML=<A
                    href="https://nginx.org">Nginx</STRONG></A>; outerText=Nginx; tagName=A; href=https://nginx.org},
                    @{innerHTML=<IMG alt="[ Powered by Rocky Linux ]" src="icons/poweredby.png">; innerText=;
                    outerHTML=<A id=rocky-poweredby href="https://rockylinux.org/"><IMG alt="[ Powered by Rocky Linux
                    ]" src="icons/poweredby.png"></A>; outerText=; tagName=A; id=rocky-poweredby;
                    href=https://rockylinux.org/}...}
ParsedHtml        : System.__ComObject
RawContentLength  : 7620
```

**🌞 Vérifier les logs d'accès**
```bash
[slayz@web nginx]$ sudo cat /var/log/nginx/access.log | tail -n 3
192.168.56.1 - - [19/Feb/2024:14:45:40 +0100] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" "-"
192.168.56.1 - - [19/Feb/2024:14:45:41 +0100] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" "-"
192.168.56.1 - - [19/Feb/2024:14:46:08 +0100] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" "-"
```
### 5. Modif de la conf du serveur web
**🌞 Changer le port d'écoute**
```bash
[slayz@web ~]$ sudo cat /etc/nginx/nginx.conf | grep 8080
        listen       8080;
        listen       [::]:8080;
[slayz@web ~]$ sudo systemctl restart nginx
[slayz@web ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Mon 2024-02-19 14:51:18 CET; 4s ago
    Process: 12381 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 12382 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 12383 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 12384 (nginx)
      Tasks: 2 (limit: 4673)
     Memory: 2.0M
        CPU: 24ms
     CGroup: /system.slice/nginx.service
             ├─12384 "nginx: master process /usr/sbin/nginx"
             └─12385 "nginx: worker process"
[slayz@web ~]$ ss -alntpu | grep 8080
tcp   LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*
tcp   LISTEN 0      511             [::]:8080         [::]:*
[slayz@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[slayz@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[slayz@web ~]$ sudo firewall-cmd --reload
success
```
```powershell
PS C:\Users\melb3> curl 192.168.56.112:8080                                                                                                         

StatusCode        : 200
StatusDescription : OK
Content           : <!doctype html>
                    <html>
                      <head>
                        <meta charset='utf-8'>
                        <meta name='viewport' content='width=device-width, initial-scale=1'>
                        <title>HTTP Server Test Page powered by: Rocky Linux</title>
                       ...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 7620
                    Content-Type: text/html
                    Date: Mon, 19 Feb 2024 13:53:47 GMT
                    ETag: "63dc2b1f-1dc4"
                    Last-Modified: Thu, 02 Feb 202...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 7620], [Content-Type, text/html]...}
Images            : {@{innerHTML=; innerText=; outerHTML=<IMG alt="[ Powered by Rocky Linux ]" src="icons/poweredby.png">; outerText=;
                    tagName=IMG; alt=[ Powered by Rocky Linux ]; src=icons/poweredby.png}, @{innerHTML=; innerText=; outerHTML=<IMG
                    src="poweredby.png">; outerText=; tagName=IMG; src=poweredby.png}}
InputFields       : {}
Links             : {@{innerHTML=<STRONG>Rocky Linux website</STRONG>; innerText=Rocky Linux website; outerHTML=<A
                    href="https://rockylinux.org/"><STRONG>Rocky Linux website</STRONG></A>; outerText=Rocky Linux website; tagName=A;
                    href=https://rockylinux.org/}, @{innerHTML=Apache Webserver</STRONG>; innerText=Apache Webserver; outerHTML=<A
                    href="https://httpd.apache.org/">Apache Webserver</STRONG></A>; outerText=Apache Webserver; tagName=A;
                    href=https://httpd.apache.org/}, @{innerHTML=Nginx</STRONG>; innerText=Nginx; outerHTML=<A
                    href="https://nginx.org">Nginx</STRONG></A>; outerText=Nginx; tagName=A; href=https://nginx.org}, @{innerHTML=<IMG alt="[
                    Powered by Rocky Linux ]" src="icons/poweredby.png">; innerText=; outerHTML=<A id=rocky-poweredby
                    href="https://rockylinux.org/"><IMG alt="[ Powered by Rocky Linux ]" src="icons/poweredby.png"></A>; outerText=; tagName=A;
                    id=rocky-poweredby; href=https://rockylinux.org/}...}
ParsedHtml        : System.__ComObject
RawContentLength  : 7620
```

**🌞 Changer l'utilisateur qui lance le service**
```bash
[slayz@web ~]$ sudo useradd -m -d /home/web web
[slayz@web ~]$ sudo passwd web
[slayz@web ~]$ sudo cat /etc/nginx/nginx.conf | grep user
user web;
[slayz@web ~]$ sudo systemctl restart nginx
[slayz@web ~]$ ps -ef | grep web
web        12446   12445  0 15:00 ?        00:00:00 nginx: worker process
```
**🌞 Changer l'emplacement de la racine Web**
```bash
[slayz@web ~]$ sudo mkdir /var/www/site_web_1/ -p
[slayz@web ~]$ sudo nano /var/www/site_web_1/index.html
<h1>kévin</h1>
[slayz@web ~]$ sudo cat /etc/nginx/conf.d/192.168.56.112.conf
server {
    listen       8080;
    server_name  192.168.56.112;
    root         /var/www/site_web_1;
        index        index.html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
          location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
          location = /50x.html {
        }
    }
```

```bash
PS C:\Users\melb3> curl 192.168.56.112:8080


StatusCode        : 200
StatusDescription : OK
Content           : <h1>kÃ©vin</h1>

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 16
                    Content-Type: text/html
                    Date: Mon, 19 Feb 2024 15:42:46 GMT
                    ETag: "65d36f69-10"
                    Last-Modified: Mon, 19 Feb 2024 15...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 16], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : System.__ComObject
RawContentLength  : 16
```

### 6. Deux sites web sur un seul serveur
**🌞 Repérez dans le fichier de conf**
```bash
[slayz@web ~]$ sudo cat /etc/nginx/conf.d/192.168.56.112.conf | grep include
        include /etc/nginx/default.d/*.conf;
```
**🌞 Créez le fichier de configuration pour le premier site**
```bash
[slayz@web ~]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
server {
    listen       8080;
    server_name  192.168.56.112;
    root         /var/www/site_web_1;
        index        index.html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
          location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
          location = /50x.html {
        }
    }
```

**🌞 Créez le fichier de configuration pour le deuxième site**
```bash
[slayz@web ~]$ sudo cat /etc/nginx/conf.d/site_web_2.conf
server {
    listen       8888;
    server_name  192.168.56.112;
    root         /var/www/site_web_2;
        index        index.html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
          location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
          location = /50x.html {
        }
    }
```
**🌞 Prouvez que les deux sites sont disponibles**
```bash
PS C:\Users\melb3> curl 192.168.56.112:8080


StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                        <title>Symphony Accueil</title>
                        <meta name="viewport" content="width=device-width, initial-scale=0.8" />
                        <link rel="stylesheet" type="text/css" href="../asset...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 5137
                    Content-Type: text/html
                    Date: Mon, 19 Feb 2024 20:53:07 GMT
                    ETag: "65d3b8b5-1411"
                    Last-Modified: Mon, 19 Feb 202...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 5137], [Content-Type, text/html]...}
Images            : {@{innerHTML=; innerText=; outerHTML=<IMG alt=logo src="../assets/img/image 9.png">; outerText=; tagName=IMG; alt=logo;
                    src=../assets/img/image 9.png}, @{innerHTML=; innerText=; outerHTML=<IMG alt=""
                    src="https://groupietrackers.herokuapp.com/api/images/alecBeenjamin.jpeg">; outerText=; tagName=IMG; alt=;
                    src=https://groupietrackers.herokuapp.com/api/images/alecBeenjamin.jpeg}, @{innerHTML=; innerText=; outerHTML=<IMG alt=""
                    src="https://groupietrackers.herokuapp.com/api/images/linkinpark.jpeg">; outerText=; tagName=IMG; alt=;
                    src=https://groupietrackers.herokuapp.com/api/images/linkinpark.jpeg}, @{innerHTML=; innerText=; outerHTML=<IMG alt=""
                    src="https://groupietrackers.herokuapp.com/api/images/imagineDragons.jpeg">; outerText=; tagName=IMG; alt=;
                    src=https://groupietrackers.herokuapp.com/api/images/imagineDragons.jpeg}...}
InputFields       : {@{innerHTML=; innerText=; outerHTML=<INPUT id=artist-search class=input1 name=q autocomplete="off" placeholder="Recherchez
                    une musique, un artiste ici :">; outerText=; tagName=INPUT; id=artist-search; class=input1; name=q; autocomplete=off;
                    placeholder=Recherchez une musique, un artiste ici :}, @{innerHTML=; innerText=; outerHTML=<INPUT class=loupe
                    src="../assets/img/loupe.png" type=image value=Submit>; outerText=; tagName=INPUT; class=loupe; src=../assets/img/loupe.png;
                    type=image; value=Submit}}
Links             : {@{innerHTML=Accueil; innerText=Accueil; outerHTML=<A class=textNav href="/accueil">Accueil</A>; outerText=Accueil; tagName=A;
                    class=textNav; href=/accueil}, @{innerHTML=Rechercher; innerText=Rechercher; outerHTML=<A class=textNav
                    href="/search">Rechercher</A>; outerText=Rechercher; tagName=A; class=textNav; href=/search}, @{innerHTML=Billboard;
                    innerText=Billboard; outerHTML=<A class=textNav href="/billboard">Billboard</A>; outerText=Billboard; tagName=A;
                    class=textNav; href=/billboard}, @{innerHTML=Play; innerText=Play; outerHTML=<A class=textNav style="MARGIN-TOP: 20%"
                    href="/game">Play</A>; outerText=Play; tagName=A; class=textNav; style=MARGIN-TOP: 20%; href=/game}...}
ParsedHtml        : System.__ComObject
RawContentLength  : 5137
```

```bash
PS C:\Users\melb3> curl 192.168.56.112:8888


StatusCode        : 200
StatusDescription : OK
Content           : <h1>fffff</h1>

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 15
                    Content-Type: text/html
                    Date: Mon, 19 Feb 2024 20:53:46 GMT
                    ETag: "65d3b158-f"
                    Last-Modified: Mon, 19 Feb 2024 19:...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 15], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : System.__ComObject
RawContentLength  : 15
```
