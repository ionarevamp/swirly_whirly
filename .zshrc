alias luajit="$HOME/workspace/.gitignore/LUAJIT/usr/local/bin/luajit"
gitclone() {
    git clone https://github.com/$1/$2
    echo entering directory \'$2\'
    cd $2
}
alias cmake="$HOME/workspace/cmake/usr/local/bin/cmake"
alias goband="$aliases[luajit] src/main.lua"
alias rm="rm -v"