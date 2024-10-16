#!/bin/bash

set -e

FORCE=0  # Force replace dotfiles when "1"
if [ "$1" == "-f" ]; then
    FORCE=1
fi

PIP=pip

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Dotfiles script dir: $DOTFILES

################################################################################
##############################  PREREQUISITES  #################################
################################################################################

# Install Python 3 from homebrew. We need to do this before nvim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get install python3-dev python3-pip
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install python || true
    brew install pipx
    PIP=pipx
    #$PIP install --upgrade pip setuptools
fi

# Install zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ ! -d $HOME/.oh-my-zsh ]; then
        # assume Bash, then we don't have zsh yet
        echo "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if [ ! -d $HOME/.oh-my-zsh ]; then
        # assume Bash, then we don't have zsh yet
        echo "Installing oh-my-zsh..."
        sudo apt install zsh git-core
        wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
        chsh -s `which zsh`
    fi
fi


################################################################################
################################  DOTFILES  ####################################
################################################################################

function install_dotfile {
    SOURCE=$DOTFILES/$1
    TARGET=$HOME/.$1
    if [ "$2" == "force" ]; then
        FORCE_THIS=1
    else
        FORCE_THIS=$FORCE
    fi
    if [ -f "$TARGET" -o -L "$TARGET" ]; then
        if [ "$FORCE_THIS" == "1" ]; then
            # Force replace dotfiles
            mv $TARGET ${TARGET}.bak
            ln -s $SOURCE $TARGET
            echo Replacing $TARGET: backing up to ${TARGET}.bak
        else
            echo Skipping $TARGET: already exists
        fi
    else
        ln -s $SOURCE $TARGET
        echo Installed to $TARGET: $SOURCE
    fi
}

install_dotfile zshrc force
install_dotfile gitconfig
install_dotfile hgrc
install_dotfile aliases
install_dotfile my_env
install_dotfile pythonrc
install_dotfile vimrc
install_dotfile tmux.conf


################################################################################
##################################  TOOLS  #####################################
################################################################################

# Install neovim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install neovim
fi

mkdir -p $HOME/.config/nvim/autoload
ln -fs $DOTFILES/init.vim $HOME/.config/nvim/init.vim

# # Install neovim python support
# if [[ "$OSTYPE" == "linux-gnu" ]]; then
#     python3 -m pip install --user --upgrade pynvim
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#     python3 -m pip install --user --upgrade pynvim
# fi

# GnuPG
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "Skipping GnuPG installation for Linux"
    # TODO(serialx): Add GnuPG for Linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install gnupg
    brew install pinentry-mac
    mkdir -p ~/.gnupg
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    killall gpg-agent || true
fi

# Install plug for neovim
if [ ! -f $HOME/.config/nvim/autoload/plug.vim ]; then
    echo "Installing vim plug..."
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo "Installing vim plugins..."
    nvim +PlugInstall +qa
    reset  # Reset as vim can cause terminal to glitch
fi

# Install SCM Breeze
if [ ! -f "$HOME/.scm_breeze/scm_breeze.sh" ]; then
    git clone https://github.com/scmbreeze/scm_breeze.git $HOME/.scm_breeze
    $HOME/.scm_breeze/install.sh
fi

# Install fzf
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "No fzf install support in linux yet"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fzf
fi

################################################################################
##################################  ALIAS  #####################################
################################################################################

# Link up bashrc/zshrc to aliases
ALIAS_SRC=$"source $HOME/.aliases"

function install_alias {
    TARGET=$1
    if grep -q "$ALIAS_SRC" "$TARGET"; then
        echo "Skipping $TARGET: alias sourcing already exists"
    else 
        echo "Inserting alias sourcing to $TARGET"
        echo "# AUTOMATIC INSERTED BY github.com/serialx/dotfiles install.sh script" >> $TARGET
        echo "$ALIAS_SRC" >> $TARGET
        echo "# AUTOMARIC INSERT END" >> $TARGET
    fi
}

# We don't need to install aliases in zsh because it's already there
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    install_alias $HOME/.bashrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_alias $HOME/.bash_profile
fi

# Install pyenv
brew install pyenv
