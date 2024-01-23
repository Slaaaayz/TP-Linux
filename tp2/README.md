# TP2 : Appréhension d'un système Linux
## SOMMAIRE 
- [Partie 1 : Files and users](#partie-1--files-and-users)
    - [I. Fichiers](#i-fichiers)
        -  [1. Find me](#1-find-me)
    - [II. Users](#ii-users)
        - [1. Nouveau user](#1-nouveau-user)
        - [2. Infos enregistrées par le système](#2-infos-enregistrées-par-le-système)
        - [3. Connexion sur le nouvel utilisateur](#3-connexion-sur-le-nouvel-utilisateur)
- [Partie 2 : Programmes et paquets](#partie-2--programmes-et-paquets)
    - [I. Programmes et processus](#i-programmes-et-processus)
        - [1. Run then kill](#1-run-then-kill)
        - [2. Tâche de fond](#2-tâche-de-fond)
        - [3. Find paths](#3-find-paths)
        - [4. La variable PATH](#4-la-variable-path)  
    - [II. Paquets](#ii-paquets)
- [Partie 3 : Poupée russe](#partie-3--poupée-russe)
# Partie 1 : Files and users
## I. Fichiers
### 1. Find me

**🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur**

```bash
[slayz@localhost ~]$ pwd
/home/slayz
```

**🌞 Trouver le chemin du fichier de logs SSH**
```bash
[slayz@localhost /]$ sudo cat var/log/secure
```
**🌞 Trouver le chemin du fichier de configuration du serveur SSH**
```bash
[slayz@localhost /]$ sudo cat etc/ssh/sshd_config
```

## II. Users

### 1. Nouveau user

**🌞 Créer un nouvel utilisateur**
```bash
[slayz@localhost /]$ sudo useradd -m -d /home/papier_alu/ -s /bin/bash marmotte
[slayz@localhost /]$ sudo passwd marmotte
```
### 2. Infos enregistrées par le système

**🌞 Prouver que cet utilisateur a été créé**
```bash
[slayz@localhost /]$ sudo cat etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu/:/bin/bash
```

**🌞 Déterminer le hash du password de l'utilisateur marmotte**
```bash
[slayz@localhost /]$ sudo cat etc/shadow | grep marmotte
[sudo] password for slayz:
marmotte:$6$iSwi3SHqVJ9WXzRB$HQOC61ksVS30ZPdCDln10MdEwM2JyZHyzsIkPs.wEj5j2ZX2wbBFly2FeMTlGsbKQpoLcj4RuP51nuAIOODVd1:19744:0:99999:7:::
```
### 3. Connexion sur le nouvel utilisateur
**🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur**
```bash
[slayz@localhost ~]$ exit
```
**🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte**
```bash
[marmotte@localhost home]$ ls slayz/
ls: cannot open directory 'slayz/': Permission denied
```
# Partie 2 : Programmes et paquets
## I. Programmes et processus
### 1. Run then kill
**🌞 Lancer un processus sleep**
```bash
[slayz@localhost ~]$ ps -ef | grep sleep
slayz       1816    1770  0 15:48 pts/0    00:00:00 sleep 1000
```

**🌞 Terminez le processus sleep depuis le deuxième terminal**

```bash
[slayz@localhost ~]$ kill 1816
```
### 2. Tâche de fond
**🌞 Lancer un nouveau processus sleep, mais en tâche de fond**

```bash
[slayz@localhost ~]$ sleep 1000&
[1] 1833
```

**🌞 Visualisez la commande en tâche de fond**
```bash
[slayz@localhost ~]$ slayz       1833    1770  0 15:56 pts/0    00:00:00
 sleep 1000
```

### 3. Find paths
**🌞 Trouver le chemin où est stocké le programme sleep**
```bash
[slayz@localhost ~]$ ls -al /bin/sleep | grep sleep
-rwxr-xr-x. 1 root root 36312 Apr 24  2023 /bin/sleep
```

**🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc**
```bash
[slayz@localhost ~]$ sudo find / -name .bashrc
[sudo] password for slayz:
/etc/skel/.bashrc
/root/.bashrc
/home/slayz/.bashrc
/home/papier_alu/.bashrc
```
### 4. La variable PATH
**🌞 Vérifier que**
```bash
[slayz@localhost /]$ which sleep
/usr/bin/sleep
[slayz@localhost /]$ which ssh
/usr/bin/ssh
[slayz@localhost /]$ which ping
/usr/bin/ping
```

## II. Paquets
**🌞 Installer le paquet git**
```bash
[slayz@localhost ~]$ sudo dnf install git 
```
**🌞 Utiliser une commande pour lancer git**
```bash
[slayz@localhost ~]$ which git
/usr/bin/git
```

**🌞 Installer le paquet nginx**
```bash
[slayz@localhost ~]$ sudo dnf install nginx
```

**🌞 Déterminer**
```bash
[slayz@localhost /]$ cd var/log/nginx/
[slayz@localhost /]$ sudo cat etc/nginx/nginx.conf
```

**🌞 Mais aussi déterminer...**
```bash
[slayz@localhost /]$ cd etc/yum.repos.d/
[slayz@localhost yum.repos.d]$ grep -nri -E '^mirrorlis'
```

# Partie 3 : Poupée russe
**🌞 Récupérer le fichier meow**
```bash
[slayz@localhost ~]$ sudo dnf install wget
[slayz@localhost ~]$ wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false

```
**🌞 Trouver le dossier dawa/**
```bash
[slayz@localhost ~]$ sudo dnf install unzip 
[slayz@localhost ~]$ mv meow?inline=false meow
[slayz@localhost ~]$ file meow
[slayz@localhost ~]$ mv meow meow.zip
[slayz@localhost ~]$ unzip meow.zip
```

**🌞 Dans le dossier dawa/, déterminer le chemin vers**  
- **le seul fichier de 15Mo**
```bash
[slayz@localhost ~]$ find dawa/ -size 15M
dawa/folder31/19/file39
```
- **le seul fichier qui ne contient que des 7**
```bash
[slayz@localhost dawa]$ grep -r 7777777
folder43/38/file41:77777777777
```
- **le seul fichier qui est nommé cookie**
```bash
[slayz@localhost dawa]$ find -name cookie
./folder14/25/cookie
```

- **le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un .)**
```bash
[slayz@localhost dawa]$ find -name ".*"
.
./folder32/14/.hidden_file
```
- **le seul fichier qui date de 2014**
```bash
[slayz@localhost dawa]$ find -newermt '2014-01-01 23:00' -not -newermt '2015-01-01 23:00'
./folder36/40/file43
```

- **le seul fichier qui a 5 dossiers-parents**
```bash
[slayz@localhost dawa]$ find -wholename "*/*/*/*/*/*/*"
./folder37/45/23/43/54/file43
```
