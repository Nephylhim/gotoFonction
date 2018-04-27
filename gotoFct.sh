my_dir="$(dirname "$0")"

#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

source $my_dir/gotoFct_functions.sh

#
# ─── MAIN ───────────────────────────────────────────────────────────────────────
#

function goto(){
    if [ ! -e "~/.gotoFct" ]; then
        touch ~/.gotoFct
    fi

    case $1 in
        "-l"|"--list"|"list")       goto_list;;
        "-a"|"--add"|"add")         goto_add "${@:2}";;
        "-r"|"--remove"|"remove")   goto_remove ${@:2};;
        "-h"|"--help"|"help")       goto_help;;
        *)                          goto_goto $@;;
    esac
}
