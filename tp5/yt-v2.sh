#!/bin/bash
#Slayz
#04/03/2024

# Définition des variables
downloads_dir="/srv/yt/downloads" # Définition du dossier de téléchargement
logs_dir="/var/log/yt" # Définition du dossier de logs
date="$(date '+[%y:%m:%d %H:%M:%S]')" #Récupération de la date
file_dir="/srv/yt/urls" # Définition du fichier d'URLs

# Vérification que le dossier download existe
if [ ! -d "$downloads_dir" ]; then
    exit 1
fi

# Vérification que le dossier logs existe
if [ ! -d $logs_dir ]; then
    exit 1
fi

# Vérification que le fichier d'URLs existe
while :; do
    file_content=$(cat $file_dir) # Récupération du contenu du fichier
    if [[ ! -z $file_content ]]; then # Vérification que le fichier n'est pas vide
        echo "$file_content" | while read url; do # Boucle sur chaque URL
            if [[ $url == https* ]]; then # Vérification que l'URL est bien une URL youtube
                title=$(/usr/local/bin/youtube-dl -e "${url}") # Récupération du titre de la vidéo
                # Vérification que le nom de la vidéo est disponible puis téléchargement
                if [ -d "/srv/yt/downloads/${title}" ]; then
                    echo "Une vidéo avec le même titre a déjà été downloaded. Avant de télécharger ou retélécharger, vous devez la supprimer"
                else
                    mkdir "/srv/yt/downloads/${title}" # Création du dossier de téléchargement
                fi
                /usr/local/bin/youtube-dl -o "/srv/yt/downloads/$title/$title.mp4" --format mp4 $url > /dev/null # Téléchargement de la vidéo
                /usr/local/bin/youtube-dl --get-description "${url}" > "/srv/yt/downloads/$title/description" # Téléchargement de la description
                echo "Video ${url} was downloaded." # Affichage de la confirmation
                echo "File path : /srv/yt/downloads/$title/$title.mp4"  # Affichage du chemin du fichier
                # Écriture dans les logs
                echo "[${date}] Video ${url} was downloaded. File path : ${downloads_dir}/${title}" >> /var/log/yt/download.log
            fi
        done
        echo "" > $file_dir # Vidage du fichier
    fi
    sleep 10 # Attente de 10 secondes
done
