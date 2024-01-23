# TP1 : Casser avant de construire

## II. Casser
### 2. Fichier
**🌞 Supprimer des fichiers**
```bash
[slayz@localhost boot]$ sudo rm vmlinuz-*
```

### 3. Utilisateurs

**🌞 Mots de passe**
- trouvez donc un moyen de lister les utilisateurs, et trouver ceux qui ont déjà un mot de passe
```bash
[slayz@localhost ~]$ cat /etc/passwd
🌞 root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:65534:65534:Kernel Overflow User:/:/sbin/nologin
systemd-coredump:x:999:997:systemd Core Dumper:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
tss:x:59:59:Account used for TPM access:/dev/null:/sbin/nologin
sssd:x:998:995:User for sssd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/usr/share/empty.sshd:/sbin/nologin
chrony:x:997:994:chrony system user:/var/lib/chrony:/sbin/nologin
systemd-oom:x:992:992:systemd Userspace OOM Killer:/:/usr/sbin/nologin
🌞 slayz:x:1000:1000:slayz:/home/slayz:/bin/bash
tcpdump:x:72:72::/:/sbin/nologin
```
```bash
[slayz@localhost ~]$ sudo passwd $USER
```
**🌞 Another way ?**
```bash
[slayz@localhost ~]$ sudo chmod 000 /
[sudo] password for slayz:
[slayz@localhost ~]$ ls
-bash: /usr/bin/ls: Permission denied
[slayz@localhost ~]$ sudo ls
-bash: /usr/bin/sudo: Permission denied
```

### 4. Disques

**🌞 Effacer le contenu du disque dur**
```bash
dd if=/dev/zero of=/dev/sda2 bs=4M.
```

### 5. Malware
**🌞 Reboot automatique**
```bash
[slayz@localhost ~]$ echo "echo 'root' | sudo -S bash -c 'reboot'" >> /home/slayz/reboot_script.sh
[slayz@localhost ~]$ echo "/home/slayz/reboot_script.sh" >> /home/slayz/.bash_profile
```


### 6. You own way
**🌞 Trouvez 4 autres façons de détuire la machine**


```bash 
[slayz@localhost ~]$ echo "#!/bin/bash" > /home/slayz/spam.sh
[slayz@localhost ~]$ echo "trap '' INT" >> /home/slayz/spam.sh
[slayz@localhost ~]$ echo "while true" >> /home/slayz/spam.sh
[slayz@localhost ~]$ echo "do" >> /home/slayz/spam.sh
[slayz@localhost ~]$ echo "  echo -e '\e[1;31mBambou aymeric\e[1;32mGay\e[1;31m!'" >> /home/slayz/spam.sh
[slayz@localhost ~]$ echo "  echo -e '\e[0m'" >> /home/slayz/spam.sh
[slayz@localhost ~]$ echo "done" >> /home/slayz/spam.sh
[slayz@localhost ~]$ chmod +x /home/slayz/spam.sh

[slayz@localhost ~]$ echo "/home/slayz/spam.sh" >> /home/slayz/.bash_profile
```

```bash
[slayz@localhost ~]$ while true; do ( ( ping 1.1.1.1 -c 1 ) & ); done
```

```bash
[slayz@localhost ~]$ rm -rf /bin/bash
```

```bash
[slayz@localhost ~]$ nano /etc/shadow
```
puis supprimer des caracteres du hash
