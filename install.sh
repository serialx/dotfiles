#!/bin/sh


echo 'Settings up dotfiles...'
if [ -x /bin/tar ]; then
    WORK_DIR=/tmp/__dotfiles
    WORK_FILE=/tmp/__dotfiles.tar.gz
    curl -L https://github.com/serialx/dotfiles/tarball/master > $WORK_FILE
    mkdir -p $WORK_DIR
    tar -zxf $WORK_FILE --directory $WORK_DIR
    mv $WORK_DIR/serialx-dotfiles*/* $WORK_DIR

    read -p 'Install serialx git/hg config? [y/n] ' INSTALL_VCS
    if [ "$INSTALL_VCS" = "y" ]; then
        cp $WORK_DIR/gitconfig ~/.gitconfig
        cp $WORK_DIR/hgrc ~/.hgrc
    fi
    cp $WORK_DIR/tmux.conf ~/.tmux.conf
    cp $WORK_DIR/vimrc ~/.vimrc
    cp -r $WORK_DIR/vim ~/.vim
    read -p 'Install serialx ssh public key for login? [y/n] ' INSTALL_SSH_KEY
    if [ "$INSTALL_SSH_KEY" = "y" ]; then
        cp -r $WORK_DIR/ssh ~/.ssh
    fi

    echo 'Installing .bashrc_serialx'
    cp $WORK_DIR/bashrc ~/.bashrc_serialx
    sed -i 's/^\. ~\/\.bashrc_serialx$//' ~/.bashrc
    echo ". ~/.bashrc_serialx" >> ~/.bashrc

    echo 'Setting up woof.py'
    mkdir -p ~/bin
    cp $WORK_DIR/bin/woof ~/bin
    chmod +x ~/bin/woof

    rm $WORK_FILE
    rm -rf $WORK_DIR
else
    echo 'Please install tar/gz to continue.'
    exit
fi

read -p 'Setup basic python environment? [y/n] ' INSTALL_PY_ENV
if [ "$INSTALL_PY_ENV" = "y" ]; then
    echo 'Setting up python environment...'
    if [ -x /usr/bin/apt-get ]; then
        sudo apt-get install python-setuptools
        sudo easy_install pip
        sudo pip install virtualenv
        sudo pip install distribute
        sudo pip install notifo  # for notifo notifications
    else
        echo 'Error: Not debian?'
    fi
fi

if [ ! -f ~/.notifo_api_key ]; then
    read -p 'Do you have a notifo account? [y/n] ' INSTALL_NOTIFO
    if [ "$INSTALL_NOTIFO" = "y" ]; then
        read -p 'Notifo API Key: ' NOTIFO_API_KEY
        echo "$NOTIFO_API_KEY" > ~/.notifo_api_key
    fi
fi
