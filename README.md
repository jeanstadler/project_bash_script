Une console
La console désigne historiquement un objet physique (ancien terminal avec des diodes). Dans le contexte moderne du développement web, le terme "console" fait souvent référence à la console des outils développeur dans les navigateurs.
Point clé : Historiquement, la console ne gérait que l'output (affichage).
Un terminal
Le terminal est une interface (un programme, une fenêtre) qui permet à l'utilisateur d'interagir avec le shell via une interface textuelle. Il gère :

L'input : capture les entrées utilisateur (clavier)
L'output : affiche les sorties (écran)

Le terminal est simplement l'interface graphique qui affiche du texte et transmet vos frappes clavier au shell.
Exemples : Windows Terminal, iTerm2, GNOME Terminal, le Terminal macOS
Un shell
Le shell est un programme interpréteur de commandes qui fait le lien entre le terminal et le système d'exploitation.
Rôle du shell :

Recevoir les commandes du terminal
Parser (analyser) et interpréter les chaînes de caractères
Trouver et exécuter les programmes demandés
Demander l'exécution au système d'exploitation
Récupérer les résultats et les renvoyer au terminal

Exemples de shells : Bash, Zsh, PowerShell, Fish, Git Bash
Important : Les commandes comme echo, ls, git, node sont des programmes externes au shell. Le shell les trouve grâce à la variable d'environnement PATH.
Une commande et ses arguments, comment la commande est traitée
Structure d'une commande
commande [options] [arguments]
Exemple : ls -la /home

ls : la commande (nom du programme à exécuter)
-la : les options/flags (modificateurs du comportement)
/home : l'argument (paramètre passé au programme)

Flux de traitement complet

L'utilisateur tape la commande dans le terminal
Le terminal capture la frappe et transmet la chaîne de caractères au shell
Le shell parse (analyse) la chaîne : il identifie la commande, les options et les arguments
Le shell cherche le programme correspondant à la commande dans les chemins définis par la variable PATH
Le shell demande au système d'exploitation d'exécuter le programme avec les arguments fournis
Le système d'exploitation exécute le programme et génère un résultat
Le shell récupère le résultat et le formate si nécessaire
Le terminal affiche le résultat à l'écran

La variable PATH
Le PATH est une variable d'environnement contenant une liste de chemins où le shell va chercher les programmes exécutables.
"Command not found" signifie :

Soit le programme n'existe pas sur votre système
Soit le programme existe mais son chemin n'est pas dans le PATH
# project_bash_script
