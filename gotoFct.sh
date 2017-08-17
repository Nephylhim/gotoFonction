function goto(){
    if [ ! -e "~/.gotoFct" ]; then
        touch ~/.gotoFct
    fi

    case $1 in
        "-l"|"--list"|"list")
            echo "Liste des alias :"; echo ""
            while read line; do
                alias=${line%:*}
                pwd=${line#*:}
                echo "$alias -> $pwd"
            done < ~/.gotoFct
            ;;
        "-a"|"--add"|"add")
            case $# in
                2)
                    new="$2:$(pwd)"
                    echo $new >> /home/$USER/.gotoFct
                    ;;
                3)
                    new="$2:$3"
                    echo $new >> ~/.gotoFct
                    ;;
                *)
                    echo "La commande est goto add <alias> <pwd> (si pwd null, pwd prend le répertoire courant comme chemin)"
                    echo "Tapez 'goto -h' pour afficher l'aide"
                    ;;
            esac
            ;;
        "-r"|"--remove"|"remove")
            if [[ $# != 2 ]]; then
                echo "La commande est goto -r <alias>"
                echo "Tapez 'goto -h' pour afficher l'aide"
            else
                sed -i.bak "/$2:/d" ~/.gotoFct
                echo "$2 supprimé !"
            fi
            ;;
        "-h"|"--help"|"help")
            echo "Utilisation : goto ALIAS"
            echo "         ou : goto OPTION ALIAS [CHEMIN]"
            echo "Permet de se déplacer rapidement dans l'arborescence via des alias."
            echo "Les alias/chemins sont ajoutés au fichier ~/.gotoFct"
            echo ""
            echo "Options :"
            echo "  -l, --list,   list          Liste les alias disponibles suivis de leur chemin"
            echo "  -a, --add,    add           Ajoute un alias dans la base"
            echo "  -r, --remove, remove        Supprime un alias dans la base"
            echo "  -h, --help,   help          Affiche l'aide"
            ;;
        *)
            if [[ $# == 1 ]]; then
                trouve=0
                while read line; do
                    alias=${line%:*}
                    pwd=${line#*:}
                    if [[ $alias == $1 ]]; then
                        cd $pwd;
                        trouve=1
                        break;
                    fi
                done < ~/.gotoFct
                if [[ $trouve == 0 ]]; then
                    while read line; do
                        alias=${line%:*}
                        pwd=${line#*:}
                        if [[ $alias == *$1* ]]; then
                            cd $pwd;
                            trouve=1
                            break;
                        fi
                    done < ~/.gotoFct

                    if [[ $trouve == 0 ]]; then
                        echo "Alias non trouvé"
                        echo "Tapez 'goto -h' pour afficher l'aide"
                    fi
                fi
            else
                echo "Utilisation : goto ALIAS"
                echo "         ou : goto OPTION ALIAS [CHEMIN]"
                echo "Tapez 'goto -h' pour afficher l'aide"
            fi
            ;;
    esac
}
