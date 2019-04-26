used_shell=`ps -hp $$|awk 'END {print $NF;}'`

if [[ $used_shell == *"bash"* ]]; then
    my_dir="$(dirname "${BASH_SOURCE[0]}")"
elif [[ $used_shell == *"zsh"* ]]; then
    my_dir="$(dirname "$0")"
fi

#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

source $my_dir/gotoFct_functions.sh

#
# ─── INIT ───────────────────────────────────────────────────────────────────────
#

if [[ $used_shell == *"zsh"* ]]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
fi

#if [[ $used_shell == "/usr/bin/zsh" ]]; then
#else
#    complete -W "-a -r -l -h" goto
#fi
complete -F goto_completion goto

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
