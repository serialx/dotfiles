#!/usr/bin/env bash
# Modified From: https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Cask Install
#brew cask install java  # installs Java 9
#brew cask install caskroom/versions/java8
brew cask install adoptopenjdk/openjdk/adoptopenjdk8

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget` with IRI support.
brew install wget

# Install more recent versions of some OS X tools.
#brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install tmux

brew install bfg
brew install binutils
brew install nmap
brew install xz

brew install git
brew install git-lfs
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install speedtest_cli
brew install ssh-copy-id
brew install testssl
brew install tree
brew install vbindiff
brew install zopfli

brew install z

brew install ruby
brew install graphviz
brew install jq

# rg / fd
brew install rg
brew install fd

# tag + rg integration: https://github.com/aykamko/tag
brew tap aykamko/tag-ag
brew install tag-ag

# Company related
brew install terraform
brew install vault
brew install kubectl
brew tap versent/homebrew-taps
brew install saml2aws

# Remove outdated versions from the cellar.
brew cleanup
