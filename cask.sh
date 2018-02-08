#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Cask Install
#brew cask install java  # installs Java 9
brew cask install caskroom/versions/java8
brew cask install sequel-pro

