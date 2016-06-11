#!/bin/bash

set -e

FORCE=0  # Force replace dotfiles when "1"
if [ "$1" == "-f" ]; then
    FORCE=1
fi

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Dotfiles script dir: $DOTFILES

################################################################################
##############################  PREREQUISITES  #################################
################################################################################

# Install Python 2 from homebrew. We need to do this before nvim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get install python-dev python-pip
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install python
    pip install --upgrade pip setuptools
fi

# Install zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ ! -d $HOME/.oh-my-zsh ]; then
        # assume Bash, then we don't have zsh yet
        echo "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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
install_dotfile pythonrc
install_dotfile vimrc


################################################################################
##################################  TOOLS  #####################################
################################################################################

# Install tools
if [ "$(pip show awscli)" == "" ]; then
    echo "Installing awscli..."
    pip install -q -U awscli
fi

# Install neovim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install --HEAD neovim/neovim/neovim
fi

mkdir -p $HOME/.config/nvim/autoload
ln -fs $DOTFILES/init.vim $HOME/.config/nvim/init.vim

# Install neovim python support
pip2 install -U neovim

# Install plug for neovim
if [ ! -f $HOME/.config/nvim/autoload/plug.vim ]; then
    echo Installing vim plug...
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo Installing vim plugins...
    nvim +PlugInstall +qa
    reset  # Reset as vim can cause terminal to glitch
fi

################################################################################
##################################  ALIAS  #####################################
################################################################################

# Link up bashrc/zshrc to aliases
ALIAS_SRC="source $HOME/.aliases"

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

