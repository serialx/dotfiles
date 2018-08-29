#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Cask Install
#brew cask install java  # installs Java 9
brew cask install google-chrome
brew cask install firefox
brew cask install jetbrains-toolbox
brew cask install caskroom/versions/java8
brew cask install sequel-pro
brew cask install slack
brew cask install iterm2
brew cask install iina
brew cask install jetbrains-toolbox
brew cask install docker

# Use mouse M4 M5 buttons
brew cask install sensiblesidebuttons
