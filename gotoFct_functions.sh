#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

# declare 
function goto_add(){
    local valid=1;
    echo "$#: $@"
    case $# in
        0)
            new="$(basename "$PWD"):$(pwd)"
            ;;
        1)
            new="$1:$(pwd)"
            ;;
        2)
            new="$1:$2"
            ;;
        *)
            valid=0;
            echo "La commande est goto add <alias> <pwd> (si pwd null, pwd prend le répertoire courant comme chemin)"
            echo "Tapez 'goto -h' pour afficher l'aide"
            ;;
    esac

    if [[ $valid == 1 ]]; then
        # if [[  ]]
        echo $new >> ~/.gotoFct
    fi
}

function goto_list(){
    local separator

    echo "Liste des alias :"; echo ""
    while read line; do
        alias=${line%:*}

        if [ "${#alias}" -le 8 ]; then
            separator="\t\t"
        elif [ "${#alias}" -le 16 ]; then
            separator="\t"
        else
            separator=" "
        fi
        
        pwd=${line#*:}
        
        echo "$alias$separator-> $pwd"
    done < ~/.gotoFct
}

function goto_remove(){
    if [[ $# != 1 ]]; then
        echo "La commande est goto -r <alias>"
        echo "Tapez 'goto -h' pour afficher l'aide"
    else
        sed -i.bak "/$1:/d" ~/.gotoFct
        echo "$1 supprimé !"
    fi
}

function goto_help(){
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
}

function goto_goto(){
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
}
