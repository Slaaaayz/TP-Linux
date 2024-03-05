# TP 5 : We do a little scripting
## SOMMAIRE 
- [I. Script carte d'identité](#i--script-carte-didentité)
- [II. Script youtube-dl](#ii-script-youtube-dl)
  - [B. Rendu attendu](#1-rendu-attendu)
  - [2. MAKE IT A SERVICE](#2-make-it-a-service)
    - [C. Rendu](#c-rendu)
  
## I : Script carte d'identité

**🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie**
```bash
[slayz@script idcard]$ ./idcard.sh
Machine name : script
OS : Rocky Linux and kernel version is 5.14.0-284.11.1.el9_2.x86_64
IP : 192.168.56.113
RAM : 326M memory available on 771M total memory
Disk : 4.9G space left
Top 5 processes by RAM usage :
- python3
- NetworkManager
- systemd
- systemd
- systemd
Listening ports :
  - 323 udp : chronyd
  - 22 tcp : sshd
PATH directories :
  - /home/slayz/.local/bin
  - /home/slayz/bin
  - /usr/local/bin
  - /usr/bin
  - /usr/local/sbin
  - /usr/sbin
Here's your random cat (jpg file) : https://cdn2.thecatapi.com/images/brp.jpg
```
Voir script ici : [idcard.sh](idcard.sh) 

## II. Script youtube-dl
### B. Rendu attendu
**🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie**
```bash
[slayz@script yt]$ ./yt.sh https://www.youtube.com/watch?v=bLu5k_j7otw
Video https://www.youtube.com/watch?v=bLu5k_j7otw was downloaded.
File path : /srv/yt/downloads/Mais qu'est ce que c'est que cette question, tu préfères le chocolat ou les noirs - Valentin Raffaul/Mais qu'est ce que c'est que cette question, tu préfères le chocolat ou les noirs - Valentin Raffaul.mp4
```
Voir script ici : [yt.sh](yt.sh)

**- Les logs** : Voir [logs](download.log)


## 2. MAKE IT A SERVICE
### C. Rendu

**Voir le script ici** : [yt-v2.sh](yt-v2.sh)  
**Voici le fichier de service** : [yt.service](yt.service)

**🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :**

```bash
Every 0.1s: systemctl status yt                                                                                                      script: Mon Mar  4 19:38:11 2024
● yt.service - service downloads yt
     Loaded: loaded (/etc/systemd/system/yt.service; enabled; preset: disabled)
     Active: active (running) since Mon 2024-03-04 19:31:45 CET; 6min ago
   Main PID: 40895 (yt-v2.sh)
      Tasks: 2 (limit: 4673)
     Memory: 93.2M
        CPU: 37.892s
     CGroup: /system.slice/yt.service
             ├─40895 /bin/bash /srv/yt/yt-v2.sh
             └─47696 sleep 10

Mar 04 19:31:45 script systemd[1]: Started service downloads yt.
Mar 04 19:31:58 script yt-v2.sh[40899]: Video https://www.youtube.com/watch?v=hvL1339luv0 was downloaded.
Mar 04 19:31:58 script yt-v2.sh[40899]: File path : /srv/yt/downloads/Never gonna Meow you up/Never gonna Meow you up.mp4
Mar 04 19:32:12 script yt-v2.sh[40899]: Video https://www.youtube.com/watch?v=ttgameuObLM was downloaded.
Mar 04 19:32:12 script yt-v2.sh[40899]: File path : /srv/yt/downloads/LA PLANÈTE DES SINGES 4 : Nouveau Royaume Bande Annonce VF (2024) Nouvelle/LA PLANÈTE DES SINGES 4 : Nouveau Royaume Bande Annonce VF (2024) Nouvelle.mp4
```

```bash
Mar 04 19:31:45 script systemd[1]: Started service downloads yt.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit yt.service has finished successfully.
░░
░░ The job identifier is 4438.
Mar 04 19:31:58 script yt-v2.sh[40899]: Video https://www.youtube.com/watch?v=hvL1339luv0 was downloaded.
Mar 04 19:31:58 script yt-v2.sh[40899]: File path : /srv/yt/downloads/Never gonna Meow you up/Never gonna Meow you up.mp4
Mar 04 19:32:12 script yt-v2.sh[40899]: Video https://www.youtube.com/watch?v=ttgameuObLM was downloaded.
Mar 04 19:32:12 script yt-v2.sh[40899]: File path : /srv/yt/downloads/LA PLANÈTE DES SINGES 4 : Nouveau Royaume Bande Annonce VF (2024) Nouvelle/LA PLANÈTE DES SING>
Mar 04 19:32:26 script yt-v2.sh[40899]: Video https://www.youtube.com/watch?v=YIufkbmcyA0 was downloaded.
Mar 04 19:32:26 script yt-v2.sh[40899]: File path : /srv/yt/downloads/Don't get caught! Hide Yourself w/ Proxychains and TOR/Don't get caught! Hide Yourself w/ Prox>
Mar 04 19:32:39 script yt-v2.sh[40899]: Video https://www.youtube.com/watch?v=NYgDzO8iQJ0 was downloaded.
Mar 04 19:32:39 script yt-v2.sh[40899]: File path : /srv/yt/downloads/Nmap Tutorial for Beginners/Nmap Tutorial for Beginners.mp4
lines 1061-1101/1101 (END)
```