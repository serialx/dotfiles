#!/bin/sh


echo 'Settings up dotfiles...'
if [ -x /usr/bin/git ]; then
    WORK_DIR=/tmp/__dotfiles
    git clone git://github.com/serialx/dotfiles.git $WORK_DIR

    WGET_OPT='--no-check-certificate'

    cp $WORK_DIR/bashrc ~/.bashrc_serialx
    echo ". ~/.bashrc_serialx" >> ~/.bashrc

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
    rm -rf $WORK_DIR
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
