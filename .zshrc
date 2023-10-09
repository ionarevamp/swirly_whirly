alias luajit="$HOME/workspace/.gitignore/LUAJIT/usr/local/bin/luajit"
gitclone() {
    git clone https://github.com/$1/$2
    echo entering directory \'$2\'
    cd $2
}