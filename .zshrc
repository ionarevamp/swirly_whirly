export ZSH=$HOME/.oh-my-zsh

# Themes
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

# Disable auto-upgrade
DISABLE_AUTO_UPDATE=false
DISABLE_UPDATE_PROMPT=false

# Disable % end of line mark (https://zsh.sourceforge.io/Doc/Release/Options.html#Prompting)
PROMPT_EOL_MARK=''

source $ZSH/oh-my-zsh.sh
source $HOME/workspace/source.list

# Sets default locale to en_US
export LANG=en_US.UTF-8

export NPM_CONFIG_CACHE=$HOME/.cache/npm
export YARN_CACHE_FOLDER=$HOME/.cache/yarn
export NPM_CONFIG_STORE_DIR=$HOME/.cache/pnpm

alias luajit="$HOME/workspace/.gitignore/LUAJIT/usr/local/bin/luajit"
gitclone() {
    git clone https://github.com/$1/$2
    echo entering directory \'$2\'
    cd $2
}
alias cmake="$HOME/workspace/cmake/usr/local/bin/cmake"
alias goband="$aliases[luajit] src/main.lua"