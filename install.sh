#!/bin/bash

FORCE=0  # Force replace dotfiles when "1"
if [ "$1" == "-f" ]; then
    FORCE=1
fi

################################################################################
##############################  PREREQUISITES  #################################
################################################################################

# Install newest version of vim if it does not already exist
if [ "$OSTYPE" == "linux-gnu" ]; then
    echo "Installing newest version of vim using apt-get..."
    sudo apt-get update
    sudo apt-get install vim
elif [ "$OSTYPE" == "darwin"* ]; then
    echo "Installing newest version of vim using homebrew..."
    brew update
    brew install vim
fi

# Install zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
    # assume Bash, then we don't have zsh yet
    echo "Installing oh-my-zsh..."
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi


################################################################################
################################  DOTFILES  ####################################
################################################################################

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Dotfiles script dir: $DOTFILES

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

# Install vim bundle
if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
    mkdir -p $HOME/.vim/bundle/Vundle.vim
    echo Installing vim Bundle...
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    echo Installing vim plugins...
    vim +PluginInstall +qall
    reset  # Reset as vim can cause terminal to glitch
fi

# Golang related tools
if [ ! -d $HOME/go ]; then
    echo Installing golang 1.4.x...
    GO_BRANCH=release-branch.go1.4
    git clone git@github.com:golang/go.git $HOME/go
    (cd $HOME/go && git checkout $GO_BRANCH)
    (cd $HOME/go/src && GOOS=linux GOARCH=amd64 ./make.bash --no-clean)
    (cd $HOME/go/src && GOOS=linux GOARCH=386 ./make.bash --no-clean)
    (cd $HOME/go/src && GOOS=linux GOARCH=arm ./make.bash --no-clean)
    (cd $HOME/go/src && GOOS=darwin GOARCH=amd64 ./make.bash --no-clean)
    (cd $HOME/go/src && GOOS=windows GOARCH=amd64 ./make.bash --no-clean)
fi

GO=$HOME/go/bin/go
echo Installing golang tools...
function go_get_install {
    $GO get $1
    $GO install $1
}
go_get_install "github.com/nsf/gocode"
go_get_install "golang.org/x/tools/cmd/goimports"
go_get_install "github.com/rogpeppe/godef"
go_get_install "golang.org/x/tools/cmd/oracle"
go_get_install "golang.org/x/tools/cmd/gorename"
go_get_install "golang.org/x/tools/cmd/gomvpkg"
go_get_install "github.com/golang/lint/golint"
go_get_install "github.com/kisielk/errcheck"
go_get_install "github.com/jstemmer/gotags"


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
if [ "$OSTYPE" == "linux-gnu" ]; then
    install_alias $HOME/.bashrc
elif [ "$OSTYPE" == "darwin"* ]; then
    install_alias $HOME/.bash_profile
fi

