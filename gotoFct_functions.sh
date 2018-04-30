#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

function goto_completion(){
    gotoOptions=""
    gotoAliases=""
    
    while read line; do
        al=${line%:*}
        gotoAliases+="$al "
    done < ~/.gotoFct

    case ${#COMP_WORDS[@]} in
        1)
            gotoOptions+=$gotoAliases
            gotoOptions+="-l -a -r -h"
            ;;
        2)
            case ${COMP_WORDS[1]} in
                "-")
                    gotoOptions+="-l -a -r -h"
                    ;;
                "-r")
                    gotoOptions+=$gotoAliases
                    ;;
                "-a")
                    gotoOptions+=${PWD##*/}
                    ;;
                *)
                    gotoOptions+=$gotoAliases
                    ;;
            esac
            ;;
        3)
            case ${COMP_WORDS[1]} in
                "-a")
                    gotoOptions+="$(pwd) "
                    # gotoOptions+="$(dirname "$(pwd)") "
                    ;;
                *)
                    ;;
            esac
            ;;
    esac

    COMPREPLY=($(compgen -W "$gotoOptions" "${COMP_WORDS[0]}"))
}

function goto_alias_exists(){
    local res=0
    local al

    if [[ $# != 1 ]]; then
        echo "Missing parameter"
    else
        while read line; do
            al=${line%:*}
            if [[ "$al" == "$1" ]]; then
                res=1
            fi
        done < ~/.gotoFct
    fi

    # return
    # ────────────────────────────────────────────────────────────────────────────────
    echo "$res"
}

function goto_path_exists(){
    local res=0
    local path

    if [[ $# != 1 ]]; then
        echo "Missing parameter"
    else
        while read line; do
            path=${line#*:}
            if [[ "$path" == "$1" ]]; then
                res=1
            fi
        done < ~/.gotoFct
    fi

    # return
    # ────────────────────────────────────────────────────────────────────────────────
    echo "$res"
}

function goto_add(){
    local valid=1;
    local al_exists;

    case $# in
        0)
            al_exists=$(goto_alias_exists "$(basename $(pwd))")
            path_exists=$(goto_path_exists "$(pwd)")
            new="$(basename "$PWD"):$(pwd)"
            ;;
        1)
            al_exists=$(goto_alias_exists "$1")
            path_exists=$(goto_path_exists "$(pwd)")
            new="$1:$(pwd)"
            ;;
        2)
            al_exists=$(goto_alias_exists "$1")
            path_exists=$(goto_path_exists "$2")
            new="$1:$2"
            ;;
        *)
            valid=0;
            echo "Command is goto add <alias> <path> (if path is null, it takes current directory as path)"
            echo "Type 'goto -h' to show help"
            ;;
    esac

    if [[ $al_exists == 1 ]]; then
        valid=0
        echo "An alias with this name already exist"
    fi

    if [[ $path_exists == 1 ]]; then
        valid=0
        echo "An alias with this path already exist"
    fi

    if [[ $valid == 1 ]]; then
        echo "Adding $new"
        echo $new >> ~/.gotoFct
    fi
}

function goto_list(){
    local separator

    echo "Aliases:"; echo ""
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
        echo "Command is goto -r <alias>"
        echo "Type 'goto -h' to show help"
    else
        al_exists=$(goto_alias_exists "$1")
        if [[ $al_exists == 1 ]]; then
            sed -i.bak "/$1:/d" ~/.gotoFct
            echo "$1 deleted!"
        else
            echo "This alias doesn't exist"
        fi
    fi
}

function goto_help(){
    echo "Usage: goto ALIAS"
    echo "   or: goto OPTION [ALIAS] [PATH]"
    echo "Allows you to quickly move in the system tree with aliases."
    echo "Alias/paths are added to ~/.gotoFct file"
    echo ""
    echo "Options:"
    echo "  -l, --list,   list          List available aliases followed by their path"
    echo "  -a, --add,    add           Add an alias"
    echo "  -r, --remove, remove        Delete an alias"
    echo "  -h, --help,   help          Show help"
}

function goto_goto(){
    if [[ $# == 1 ]]; then
        found=0
        while read line; do
            alias=${line%:*}
            pwd=${line#*:}
            if [[ $alias == $1 ]]; then
                cd $pwd;
                found=1
                break;
            fi
        done < ~/.gotoFct
        if [[ $found == 0 ]]; then
            while read line; do
                alias=${line%:*}
                pwd=${line#*:}
                if [[ $alias == *$1* ]]; then
                    cd $pwd;
                    found=1
                    break;
                fi
            done < ~/.gotoFct

            if [[ $found == 0 ]]; then
                echo "Alias not found"
                echo "Type 'goto -h' to show help"
            fi
        fi
    else
        echo "Usage: goto ALIAS"
        echo "   or: goto OPTION [ALIAS] [PATH]"
        echo "Type 'goto -h' to show help"
    fi
}
