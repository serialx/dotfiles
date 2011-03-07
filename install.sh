#!/bin/sh


echo 'Settings up dotfiles...'
if [ -x /usr/bin/git ]; then
    WORK_DIR=/tmp/__dotfiles
    git clone git://github.com/serialx/dotfiles.git $WORK_DIR

    WGET_OPT='--no-check-certificate'

    cp $WORK_DIR/bashrc ~/.bashrc_serialx
    echo ". ~/.bashrc_serialx" >> ~/.bashrc

    cp $WORK_DIR/gitconfig ~/.gitconfig
    cp $WORK_DIR/hgrc ~/.hgrc
    cp $WORK_DIR/tmux.conf ~/.tmux.conf
    cp $WORK_DIR/vimrc ~/.vimrc
    cp -r $WORK_DIR/vim ~/.vim
else
    echo 'Please install git to continue.'
    exit
fi

echo 'Setting up python environment...'
if [ -x /usr/bin/apt-get ]; then
    sudo apt-get install python-setuptools
    sudo easy_install pip
    sudo pip install virtualenv
    sudo pip install distribute
    sudo pip install notifo  # for notifo notifications
else
    echo 'Not debian?'
fi

read -p 'Do you have a notifo account? [y/n] ' INSTALL_NOTIFO
if [ "$INSTALL_NOTIFO" = "y" ]; then
    read -p 'Notifo API Key: ' NOTIFO_API_KEY
    echo "alias notify='notifo_cli.py -u serialx -s $NOTIFO_API_KEY -n foo'" >> ~/.bashrc_serialx
fi
