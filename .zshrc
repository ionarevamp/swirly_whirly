typeset -g "POWERLEVEL9K_INSTANT_PROMPT=quiet"
clear
local term_cols=$(tput cols)
local __blankspace=" "
for (( i=1; i<=$(($term_cols/4)); i++ )); do
    __blankspace="$__blankspace "
done
echo "$__blankspace~ To-do list: ~"
cat "$HOME/workspace/TODO.txt"

alias luajit="$HOME/workspace/LUAJIT/usr/local/bin/luajit"
alias vim="$HOME/workspace/VIM/bin/vim"
alias ls="ls -A"
alias cdd="cd $HOME/workspace; dirs -c"

if ! [ -f "$HOME/.oh-my-zsh/custom/custom.zsh" ] ; then
    ln -s "$HOME/workspace/.zshrc" "$HOME/.oh-my-zsh/custom/custom.zsh";
fi

installp10k() {
    git clone "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k";
    sed --follow-symlinks 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$HOME/.zshrc" > /tmp/sed.tmp;
    mv /tmp/sed.tmp $HOME/.zshrc;
    zsh
}
gitclone() {
    git clone https://github.com/$1/$2
    echo entering directory \'$2\'
    cd $2
}
lss(){
    ls
    echo "dir src/:" && ls src/
    echo "dir src/lib:" && ls src/lib
}
alias cmake="$HOME/workspace/cmake/usr/local/bin/cmake"
alias rm="rm -v"
goband() {
    ttyctl -u
    luajit src/main.lua
    tput cnorm
}
gotest() {
    tput civis
    luajit "test$@.lua"
    tput cnorm
}
alias gocomp="pushd . && cd $HOME/workspace/src/lib && gcc -c bypass.c && gcc -shared -o bypass.dll bypass.o && popd"