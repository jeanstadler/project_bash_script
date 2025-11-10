echo ""
echo "==========================================================="
echo "Bash script starting at $(date '+%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "Script full path: '$(realpath "$0")'"

# supprimer le dossier s'il existe déjà
rm -rf archive_tmp

# puis créer le dossier temporaire de travail
mkdir archive_tmp


# awk permet de traiter les fichiers text ligne par ligne
# nr==1 veut dire ligne numéro 1 
# nr==2 veut dire ligne numéro 2
first_url=$(awk 'NR==1' "$1")
second_url=$(awk 'NR==2' "$1")
third_url=$(awk 'NR==3' "$1")
echo ""
echo "--1/3--"
echo "downloading first $first_url"
# curl permet de faire des requettes HTTP
# -o est une option qui permet de dire où enregistrer le fichier téléchargé
curl "$first_url" -o "archive_tmp/de.json"





echo "----"
echo ""
echo "--2/3--"
echo "downloadin second url $second_url"
curl "$second_url" -o "archive_tmp/fr.json"
echo "----"
echo ""
echo "--3/3--"
echo "downloading third url $third_url"
curl "$third_url" -o "archive_tmp/es.json"
echo "----"
echo ""
echo "Bash script end at $(date '+%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "====================================================================="
