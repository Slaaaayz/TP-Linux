#!/bin/bash
#Slayz
#23/02/2024

# Définition des variables
downloads_dir="/srv/yt/downloads" # Définition du dossier de téléchargement
logs_dir="/var/log/yt" # Définition du dossier de logs
url="$1" # Récupération de l'URL
date="$(date '+[%y:%m:%d %H:%M:%S]')" #Récupération de la date
title=$(youtube-dl -e "${url}") # Récupération du titre de la vidéo
description=$(youtube-dl --get-description "${url}") # Récupération de la description de la vidéo

# Vérification qu'un argument a été entré
if [ -z "$url" ]
then
        echo "Vous devez préciser un lien."
        exit 1
fi

# Vérification que le dossier download existe
if [ ! -d "$downloads_dir" ]
then
    exit 1
fi

# Vérification que le doss logs existe
if [ ! -d $logs_dir ]
then
    exit 1
fi

# Vérification que le nom de la vidéo est dispo puis téléchargement
if [ -d "/srv/yt/downloads/${title}" ]
then
        echo "Une vidéo avec le même titre a déjà été downloaded. Avant de télécharger ou retéléchargé, vous devez la supprimer"
        exit 1
fi

mkdir "/srv/yt/downloads/${title}" # Création du dossier de téléchargement
youtube-dl -o "/srv/yt/downloads/$title/$title.mp4" --format mp4 $url > /dev/null # Téléchargement de la vidéo
youtube-dl --get-description "${url}" > "/srv/yt/downloads/$title/description" # Téléchargement de la description
echo "Video ${url} was downloaded." # Affichage de la confirmation
echo "File path : /srv/yt/downloads/$title/$title.mp4"  # Affichage du chemin du fichier


# Écriture dans les logs
echo "[${date}] Video ${url} was downloaded. File path : ${downloads_dir}/${title}" >> /var/log/yt/download.log

