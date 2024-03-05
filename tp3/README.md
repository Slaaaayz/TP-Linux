# TP3 : Services
# Sommaire

- [I. Service SSH](#i-service-ssh)  
   - [1. Analyse du service](#1-analyse-du-service)
   - [2. Modification du service](#2-modification-du-service)

- [II. Service HTTP](#ii-service-http)
   - [1. Mise en place](#1-mise-en-place)
   - [2. Analyser la configuration de NGINX](#2-analyser-la-conf-de-nginx)
   - [3. Déployer un nouveau site web](#3-déployer-un-nouveau-site-web)

- [III. Your Own Services](#iii-your-own-services)
   - [2. Analyse des services existants](#2-analyse-des-services-existants)
   - [3. Création de service](#3-création-de-service)

## I. Service SSH
### 1. Analyse du service
**🌞 S'assurer que le service sshd est démarré**
```bash
[slayz@node1 ~]$ sudo systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; pre>     Active: active (running) since Mon 2024-01-29 13:38:36 CET; 10min >       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 682 (sshd)
      Tasks: 1 (limit: 4673)
     Memory: 4.8M
        CPU: 151ms
     CGroup: /system.slice/sshd.service
             └─682 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 star>
Jan 29 13:38:36 localhost sshd[682]: main: sshd: ssh-rsa algorithm is d>Jan 29 13:38:36 localhost sshd[682]: Server listening on 0.0.0.0 port 2>Jan 29 13:38:36 localhost sshd[682]: Server listening on :: port 22.
Jan 29 13:38:36 localhost systemd[1]: Started OpenSSH server daemon.
Jan 29 13:43:31 localhost.localdomain sshd[1410]: main: sshd: ssh-rsa a>Jan 29 13:43:34 localhost.localdomain sshd[1410]: Accepted password for>Jan 29 13:43:34 localhost.localdomain sshd[1410]: pam_unix(sshd:session>Jan 29 13:45:30 node1.tp3.b1 sshd[1488]: main: sshd: ssh-rsa algorithm >Jan 29 13:45:31 node1.tp3.b1 sshd[1488]: Accepted password for slayz fr>Jan 29 13:45:31 node1.tp3.b1 sshd[1488]: pam_unix(sshd:session): sessio>lines 1-22/22 (END)
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Mon 2024-01-29 13:38:36 CET; 10min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 682 (sshd)
      Tasks: 1 (limit: 4673)
     Memory: 4.8M
        CPU: 151ms
     CGroup: /system.slice/sshd.service
             └─682 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 29 13:38:36 localhost sshd[682]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 13:38:36 localhost sshd[682]: Server listening on 0.0.0.0 port 22.
Jan 29 13:38:36 localhost sshd[682]: Server listening on :: port 22.
Jan 29 13:38:36 localhost systemd[1]: Started OpenSSH server daemon.
Jan 29 13:43:31 localhost.localdomain sshd[1410]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 13:43:34 localhost.localdomain sshd[1410]: Accepted password for slayz from 10.2.1.1 port 61254 ssh2
Jan 29 13:43:34 localhost.localdomain sshd[1410]: pam_unix(sshd:session): session opened for user slayz(uid=1000) by (uid=0)
Jan 29 13:45:30 node1.tp3.b1 sshd[1488]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 13:45:31 node1.tp3.b1 sshd[1488]: Accepted password for slayz from 10.2.1.1 port 61266 ssh2
Jan 29 13:45:31 node1.tp3.b1 sshd[1488]: pam_unix(sshd:session): session opened for user slayz(uid=1000) by (uid=0)
```

**🌞 Analyser les processus liés au service SSH**
```bash
[slayz@node1 ~]$ ps -ef | grep sshd
root         682       1  0 13:38 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1488     682  0 13:45 ?        00:00:00 sshd: slayz [priv]
slayz       1492    1488  0 13:45 ?        00:00:00 sshd: slayz@pts/0
```

**🌞 Déterminer le port sur lequel écoute le service SSH**
```bash
[slayz@node1 ~]$ ss -altpn | grep 22
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*
LISTEN 0      128             [::]:22           [::]:*
```

**🌞 Consulter les logs du service SSH**
- les logs du service sont consultables avec une commande journalctl
```bash
[slayz@node1 ~]$ journalctl -xe -u sshd
Jan 29 13:38:36 localhost systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 223.
Jan 29 13:38:36 localhost sshd[682]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 13:38:36 localhost sshd[682]: Server listening on 0.0.0.0 port 22.
Jan 29 13:38:36 localhost sshd[682]: Server listening on :: port 22.
Jan 29 13:38:36 localhost systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 223.
Jan 29 13:43:31 localhost.localdomain sshd[1410]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 13:43:34 localhost.localdomain sshd[1410]: Accepted password for slayz from 10.2.1.1 port 61254 ssh2
Jan 29 13:43:34 localhost.localdomain sshd[1410]: pam_unix(sshd:session): session opened for user slayz(uid=1000) by (uid=0)
Jan 29 13:45:30 node1.tp3.b1 sshd[1488]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 13:45:31 node1.tp3.b1 sshd[1488]: Accepted password for slayz from 10.2.1.1 port 61266 ssh2
Jan 29 13:45:31 node1.tp3.b1 sshd[1488]: pam_unix(sshd:session): session opened for user slayz(uid=1000) by (uid=0)
```
- AUSSI, il existe un fichier de log, dans lequel le service SSH enregistre toutes les tentatives de connexion
```bash
[slayz@node1 ~]$ sudo cat /var/log/secure | tail -n 10
Jan 29 13:49:33 localhost sudo[1524]: pam_unix(sudo:session): session closed for user root
Jan 29 14:26:14 localhost sudo[1569]:   slayz : TTY=pts/0 ; PWD=/home/slayz ; USER=root ; COMMAND=/bin/cat /var/log/sssd
Jan 29 14:26:14 localhost sudo[1569]: pam_unix(sudo:session): session opened for user root(uid=0) by slayz(uid=1000)
Jan 29 14:26:14 localhost sudo[1569]: pam_unix(sudo:session): session closed for user root
Jan 29 14:27:16 localhost sudo[1574]:   slayz : TTY=pts/0 ; PWD=/home/slayz ; USER=root ; COMMAND=/bin/cat /var/log/secure
Jan 29 14:27:16 localhost sudo[1574]: pam_unix(sudo:session): session opened for user root(uid=0) by slayz(uid=1000)
Jan 29 14:27:16 localhost sudo[1574]: pam_unix(sudo:session): session closed for user root
Jan 29 14:27:26 localhost sudo[1577]:   slayz : TTY=pts/0 ; PWD=/home/slayz ; USER=root ; COMMAND=/bin/cat /var/log/secure
Jan 29 14:27:26 localhost sudo[1577]: pam_unix(sudo:session): session opened for user root(uid=0) by slayz(uid=1000)
Jan 29 14:27:26 localhost sudo[1577]: pam_unix(sudo:session): session closed for user root
```
### 2. Modification du service
**🌞 Identifier le fichier de configuration du serveur SSH**
```bash
[slayz@node1 ~]$ sudo cat /etc/ssh/sshd_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```
- exécutez un echo $RANDOM pour demander à votre shell de vous fournir un nombre aléatoire

```bash
[slayz@node1 ~]$ echo $RANDOM
22863
```

- changez le port d'écoute du serveur SSH pour qu'il écoute sur ce numéro de port

```bash
[slayz@node1 ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 22863
```

- gérer le firewall
```bash
[slayz@node1 ~]$ sudo firewall-cmd --remove-port=22/tcp --permanent
[slayz@node1 ~]$ sudo firewall-cmd --add-port=22/tcp --permanent
[slayz@node1 ~]$ sudo firewall-cmd --reload
[slayz@node1 ~]$ sudo firewall-cmd --list-all | grep 22863
  ports: 22863/tcp
```

**🌞 Redémarrer le service**
```bash
[slayz@node1 ~]$ sudo systemctl restart sshd
```

**🌞 Effectuer une connexion SSH sur le nouveau port**
```bash
PS C:\Users\melb3> ssh slayz@10.2.1.11 -p 22863
slayz@10.2.1.11's password:
Last login: Mon Jan 29 14:53:01 2024 from 10.2.1.1
[slayz@node1 ~]$
```

## II. Service HTTP
### 1. Mise en place
**🌞 Installer le serveur NGINX**
```bash
sudo dnf install nginx
```
**🌞 Démarrer le service NGINX**
```bash
[slayz@node1 ~]$ sudo systemctl status nginx
```
**🌞 Déterminer sur quel port tourne NGINX**
- vous devez filtrer la sortie de la commande utilisée pour n'afficher que les lignes demandées

```bash
[slayz@node1 ~]$ ss -alntp | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*
LISTEN 0      511             [::]:80           [::]:*
```
- ouvrez le port concerné dans le firewall
```bash
[slayz@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[slayz@node1 ~]$ sudo firewall-cmd --reload
success
```
**🌞 Déterminer les processus liés au service NGINX**
```bash
[slayz@node1 ~]$ ps -ef | grep nginx
root       11772       1  0 14:59 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11773   11772  0 14:59 ?        00:00:00 nginx: worker process
```

**🌞 Déterminer le nom de l'utilisateur qui lance NGINX**
```bash
[slayz@node1 ~]$ sudo cat /etc/passwd | grep nginx
[sudo] password for slayz:
nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin
```
**🌞 Test !**
```bash
melb3@Maxime MINGW64 ~
$ curl http://10.2.1.11 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  3446k      0 --:--:-- --:--:-- --:--:-- 3720k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

### 2. Analyser la conf de NGINX
**🌞 Déterminer le path du fichier de configuration de NGINX**
```bash
[slayz@node1 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf
```
**🌞 Trouver dans le fichier de conf**
- les lignes qui permettent de faire tourner un site web d'accueil (la page moche que vous avez vu avec votre navigateur)

```bash
[slayz@node1 ~]$ sudo cat /etc/nginx/nginx.conf | grep server -A 12
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

```

- une ligne qui commence par include

```bash
[slayz@node1 ~]$ sudo cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include /etc/nginx/mime.types;
    include /etc/nginx/conf.d/*.conf;
```
### 3. Déployer un nouveau site web
**🌞 Créer un site web**
```bash
[slayz@node1 ~]$ sudo mkdir /var/www/
[slayz@node1 www]$ cd /var/www/
[slayz@node1 www]$ sudo mkdir tp3_linux
[slayz@node1 www]$ cd tp3_linux
[slayz@node1 tp3_linux]$ sudo touch index.html
[slayz@node1 tp3_linux]$ sudo nano index.html
<h1>Bienvenue a Gotham City</h1> 
```
**🌞 Gérer les permissions**
```bash
[slayz@node1 tp3_linux]$ sudo chown nginx /var/www/tp3_linux/
```
**🌞 Adapter la conf NGINX**
- dans le fichier de conf principal

```bash
[slayz@node1 tp3_linux]$ sudo cat /etc/nginx/nginx.conf | grep server -A 12
# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}
```
```bash
[slayz@node1 conf.d]$ echo $RANDOM
4985
```
```bash
[slayz@node1 conf.d]$ cd /etc/nginx/conf.d/
```
```bash
[slayz@node1 conf.d]$ touch apaganan.conf
```
```bash
[slayz@node1 conf.d]$ sudo cat apaganan.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 4985;

  root /var/www/tp3_linux;
}
```
**🌞 Visitez votre super site web**
```bash
melb3@Maxime MINGW64 ~
$ curl http://10.2.1.11:4985
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    33  100    33    0     0   6476      0 --:--:-- --:--:-- --:--:--  6600<h1>Bienvenue a Gotham City</h1>
```
## III. Your own services
### 2. Analyse des services existants
**🌞 Afficher le fichier de service SSH**
```bash
[slayz@node1 ~]$ sudo cat /usr/lib/systemd/system/sshd.service | grep ExecStart=
ExecStart=/usr/sbin/sshd -D $OPTIONS
```
**🌞 Afficher le fichier de service NGINX**
```bash
[slayz@node1 ~]$ sudo cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```
### 3. Création de service
**🌞 Créez le fichier /etc/systemd/system/tp3_nc.service**
```bash
[slayz@node1 system]$ sudo touch /etc/systemd/system/tp3_nc.service
[slayz@node1 system]$ echo $RANDOM
11720
[slayz@node1 system]$ cat tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 11720 -k
```
**🌞 Indiquer au système qu'on a modifié les fichiers de service**
```bash
[slayz@node1 system]$ sudo systemctl daemon-reload
```
**🌞 Démarrer notre service de ouf**
```bash
[slayz@node1 system]$ sudo systemctl start tp3_nc
```
**🌞 Vérifier que ça fonctionne**
- vérifier que le service tourne avec un systemctl status <SERVICE>
```bash
[slayz@node1 system]$ sudo systemctl status tp3_nc
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Mon 2024-01-29 16:37:55 CET; 58s ago
   Main PID: 12092 (nc)
      Tasks: 1 (limit: 4673)
     Memory: 796.0K
        CPU: 12ms
     CGroup: /system.slice/tp3_nc.service
             └─12092 /usr/bin/nc -l 11720 -k

Jan 29 16:37:55 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.
```
- vérifier que nc écoute bien derrière un port avec un ss

```bash
[slayz@node1 system]$ ss -alntp | grep 11720
LISTEN 0      10           0.0.0.0:11720      0.0.0.0:*
LISTEN 0      10              [::]:11720         [::]:*
```
- vérifer que juste ça fonctionne en vous connectant au service depuis une autre VM ou votre PC

```bash
[slayz@localhost ~]$ nc 10.2.1.11 11720
apa
```
**🌞 Les logs de votre service**
- une commande journalctl filtrée avec grep qui affiche la ligne qui indique le démarrage du service
```bash
[slayz@node1 system]$ sudo journalctl -xe -u tp3_nc | grep Started
Jan 29 16:37:55 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.
```
- une commande journalctl filtrée avec grep qui affiche un message reçu qui a été envoyé par le client
```bash
[slayz@node1 system]$ sudo journalctl -xe -u tp3_nc | grep nc
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ A start job for unit tp3_nc.service has finished successfully.
Jan 29 16:46:47 node1.tp3.b1 nc[12092]: apa
```
- une commande journalctl filtrée avec grep qui affiche la ligne qui indique l'arrêt du service
```bash
[slayz@node1 ~]$ sudo systemctl status tp3_nc | grep Active
     Active: inactive (dead)
```
**🌞 S'amuser à kill le processus**

```bash
[slayz@node1 system]$ ps -ef | grep nc
root       12092       1  0 16:37 ?        00:00:00 /usr/bin/nc -l 11720 -k
[slayz@node1 system]$ sudo kill 12092
```

**🌞 Affiner la définition du service**
```bash
[slayz@node1 ~]$ sudo nano /etc/systemd/system/tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 11720 -k
Restart=always
[slayz@node1 ~]$ sudo systemctl daemon-reload
[slayz@node1 ~]$ sudo systemctl start tp3_nc.service
[slayz@node1 ~]$ ps -ef | grep 11720
root       12288       1  0 09:03 ?        00:00:00 /usr/bin/nc -l 11720 -k
[slayz@node1 ~]$ sudo kill 12288
[slayz@node1 ~]$ sudo systemctl status tp3_nc
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 09:09:19 CET; 19s ago
   Main PID: 12307 (nc)
      Tasks: 1 (limit: 4673)
     Memory: 784.0K
        CPU: 10ms
     CGroup: /system.slice/tp3_nc.service
             └─12307 /usr/bin/nc -l 11720 -k

Jan 30 09:09:19 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.
```
# BONUS
## 1. fail2ban
```bash
[slayz@node1 ~]$ sudo dnf install epel-release
[slayz@node1 ~]$ sudo dnf install fail2ban
[slayz@node1 ~]$ sudo nano /etc/fail2ban/jail.local
  GNU nano 5.6.1                                     /etc/fail2ban/jail.local                                                [DEFAULT]
# Ban hosts for one hour:
bantime = 3600

# Override backend=auto in /etc/fail2ban/jail.conf
backend = systemd


[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/secure
maxretry = 3
[slayz@node1 ~]$ sudo systemctl start fail2ban
[slayz@node1 ~]$ sudo systemctl enable fail2ban
[slayz@node1 ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 1
|  |- Total failed:     6
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   10.2.1.1
```
