#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

function goto_add(){
    local valid=1;
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
            echo "command is goto add <alias> <path> (if path is null, it takes current directory as path)"
            echo "Type 'goto -h' to show help"
            ;;
    esac

    if [[ $valid == 1 ]]; then
        # if [[  ]]
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
        sed -i.bak "/$1:/d" ~/.gotoFct
        echo "$1 deleted!"
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
