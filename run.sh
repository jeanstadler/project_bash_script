#!/usr/bin/env bash
# couleurs pour le terminal
GREEN=$(printf '\033[0;32m')
BLUE_UNDERLINE=$(printf '\033[0;34;4m')
RESET=$(printf '\033[0m')
# verification des arguments
if [ "$#" -ne 3 ]; then
  echo "usage : $0 <fichier_urls> <dossier_downloads> <dossier_archives>"
  exit 1
fi
# variables
URLS_FILE=$1
DOWNLOAD_DIR=$2
ARCHIVE_DIR=$3
TEMP_DIR="archive_tmp"
HISTORY_FILE="execution_history.log"
# verification que le fichier d'URLs existe
if [ ! -f "$URLS_FILE" ]; then
  echo "le fichier '$URLS_FILE' est introuvable."
  exit 1
fi
# affichage de l'heure de début
start_timestamp=$(date '+%Y-%m-%dT%H:%M:%S.%3N%z')
echo ""
echo "==========================================================="
echo "> bash script starting at: $start_timestamp"
echo "> script full path: '$(realpath "$0")'"
# preparation du dossier temporaire
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
# telechargement des fichiers JSON
# on lit le fichier d'URLs ligne par ligne et on telecharge chaque ficher
url_count=0
while IFS= read -r url; do
  # nettoyage des caractères Windows (\r)
  url=${url%$'\r'}
  # ignorer les lignes vides
  if [ -z "$url" ]; then
    continue
  fi
  url_count=$((url_count + 1))
  # extrait juste le nom du fichier
  file_name=$(basename "$url")
  json_path="$TEMP_DIR/$file_name"
  headers_path="$json_path.headers"
  printf "> downloading '%s%s%s'…\n" "$BLUE_UNDERLINE" "$url" "$RESET"
  # curl -s mode silencieux, -D sauvegarde les en-tetes, -o sauvegarde le contenu
  curl -s "$url" -D "$headers_path" -o "$json_path"
  printf "  %sdone%s\n" "$GREEN" "$RESET"
# lecture depuis le fichier d'URLs
done < "$URLS_FILE"
if [ "$url_count" -eq 0 ]; then
  echo "aucune URL dans '$URLS_FILE'."
  exit 1
fi
# copie des fichiers JSON vers le dossier downloads
# on recree le dossier downloads et on y copie tous les fichiers .json
echo "> copying JSON files from '$TEMP_DIR' to '$DOWNLOAD_DIR'…"
rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"
for json_file in "$TEMP_DIR"/*.json; do
  # verifie que le fichier existe avant de copier
  if [ ! -e "$json_file" ]; then
    continue
  fi
  cp "$json_file" "$DOWNLOAD_DIR/"
done
printf "  %sdone%s\n" "$GREEN" "$RESET"
# compilation des en-têtes HTTP
# on regroupe tous les fichiers .headers dans un seul fichier headers.txt
echo "> compiling HTTP response headers from '$TEMP_DIR' to '$DOWNLOAD_DIR'…"
headers_output="$DOWNLOAD_DIR/headers.txt"
# cree un fichier vide
> "$headers_output"
for header_file in "$TEMP_DIR"/*.headers; do
  # verifie que le fichier existe
  if [ ! -e "$header_file" ]; then
    continue
  fi
  # recupere le nom du fichier
  header_name=$(basename "$header_file")
  # ajoute un séparateur
  echo "### $header_name:" >> "$headers_output"
  # ajoute le contenu
  cat "$header_file" >> "$headers_output"
  # ajoute une ligne vide
  echo "" >> "$headers_output"
done
printf "  %sdone%s\n" "$GREEN" "$RESET"
# création de l'archive compressée
# on compresse tout le dossier downloads dans une archive .tar.gz
echo "> compressing all files in '$DOWNLOAD_DIR' to '$ARCHIVE_DIR'…"
mkdir -p "$ARCHIVE_DIR"
# nom avec la date
archive_name="D$(date '+%Y-%m-%dT%H-%M-%S').tar.gz"
# compression maximale via pipe (evite le warning sur GZIP variable)
tar -C "$DOWNLOAD_DIR" -cf - . | gzip -9 > "$ARCHIVE_DIR/$archive_name"
printf "  %sdone%s (archive file name: %s)\n" "$GREEN" "$RESET" "$archive_name"
# affichage de l'heure de fin
end_timestamp=$(date '+%Y-%m-%dT%H:%M:%S.%3N%z')
echo "> bash script ending at: $end_timestamp"
echo "bye!"
echo "====================================================================="
# sauvegarde dans l'historique
echo "$start_timestamp -> $end_timestamp | URLs: $url_count | downloads: $DOWNLOAD_DIR | archive: $ARCHIVE_DIR/$archive_name" >> "$HISTORY_FILE"