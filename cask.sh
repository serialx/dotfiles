#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Cask Install
brew cask install google-chrome
brew cask install firefox
brew cask install jetbrains-toolbox
brew cask install sequel-pro
brew cask install slack
brew cask install iterm2
brew cask install iina
brew cask install jetbrains-toolbox
brew cask install visual-studio-code
brew cask install docker
brew cask install keybase

# Use mouse M4 M5 buttons
brew cask install sensiblesidebuttons
