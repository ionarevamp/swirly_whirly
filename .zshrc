clear
local term_cols=$(tput cols)
local __blankspace=" "
for (( i=1; i<=$(($term_cols/4)); i++ )); do
    __blankspace="$__blankspace "
done
echo "$__blankspace~ To-do list: ~"
cat "TODO.txt"

alias luajit="LUAJIT/usr/local/bin/luajit"
alias vim="VIM/bin/vim"
alias showdir="ls --ignore='.*'"
alias ls="ls -A"
alias cdd="cd /workspace; dirs -c"

if ! [ -f "/root/.oh-my-zsh/custom/custom.zsh" ] ; then
    ln -s "/workspace/.zshrc" "/root/.oh-my-zsh/custom/custom.zsh";
fi

installp10k() {
    sudo git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k" &&
    sed --follow-symlinks 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' \
                          "/root/.zshrc" > /tmp/sed.tmp &&
    sudo mv /tmp/sed.tmp /root/.zshrc &&
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
alias gocomp="bash compile.zsh"
refresh() {
    if [ $# -gt 0 ]; then
        tset "$@";
        echo '(Press enter to continue.)';
        read;
    else reset;
    fi;
    zsh;
}