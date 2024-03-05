#!/bin/bash
#Slayz
#23/02/2024

name=$(hostnamectl --static)
os=$(cat /etc/os-release | grep -w "NAME" | cut -d'"' -f2)
kernel_version=$(uname -r)
ip=$(hostname -i | tr -s ' ' | cut -d ' ' -f3)
ram=$(free -h --giga | grep Mem: | tr -s ' ')
storage=$(df -h / | grep / | tr -s ' ' | cut -d' ' -f4)
process_list=$(ps -ef --sort=-rss | head -6 | tail -5 | tr -s ' ' | cut -d "/" -f4 | cut -d "-" -f1 |sed 's/^/- /')
random_cat=$(curl -s https://api.thecatapi.com/v1/images/search | cut -c 2- | rev | cut -c 2- | rev )
cat=$(echo $random_cat | cut -d'"' -f8)
file=$(echo $cat | cut -d '/' -f5 | cut -d '.' -f2)


echo "Machine name : $name"
echo "OS : $os and kernel version is $kernel_version"
echo "IP : $ip"
echo "RAM : $(echo $ram | cut -d ' ' -f4) memory available on $(echo $ram | cut -d ' ' -f2) total memory"
echo "Disk : $storage space left"
echo "Top 5 processes by RAM usage :"
echo "$process_list"
echo "Listening ports :"
ss -tulne4 | tail -n +2 | while read ss; do
    port=$(echo "$ss" | tr -s ' ' | cut -d ' ' -f5 | cut -d ':' -f2)
    protocol=$(echo "$ss" | tr -s ' ' | cut -d ' ' -f1)
    program=$(echo "$ss" | tr -s ' ' | cut -d ' ' -f9 | cut -d '/' -f3 | cut -d '.' -f1)
    echo "  - $port $protocol : $program"
done

echo "PATH directories :"
echo "$PATH" | tr ':' '\n' | while read -r directory; do
    echo "  - $directory"
done
echo "Here's your random cat ($file file)  : $cat"