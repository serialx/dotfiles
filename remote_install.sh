#!/bin/bash

TARGET_DIR=$HOME/workspace/dotfiles
if [ -d $TARGET_DIR ]; then
    echo "Dotfiles already installed"
else
    echo "Cloning dotfiles..."
    mkdir -p $HOME/workspace/
    git clone git@github.com:serialx/dotfiles.git $TARGET_DIR
    cd $TARGET_DIR
    bash install.sh
fi
