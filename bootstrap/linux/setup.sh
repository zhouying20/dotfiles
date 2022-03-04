#!/usr/bin/env bash
set -euxo pipefail # -e=-o errexit, -u=-o nounset

BREW_PREFIX=$XDG_DATA_HOME/linuxbrew
if [ ! -d $BREW_PREFIX ]; then
    git clone https://github.com/Homebrew/brew $BREW_PREFIX/Homebrew
    ln -s $BREW_PREFIX/Homebrew/bin/brew $BREW_PREFIX/bin
fi
eval $($BREW_PREFIX/bin/brew shellenv)

# Install all dependencies from the Brewfile
brew bundle -v --no-lock || true

# Installing miniconda
if [ ! -d $XDG_DATA_HOME/miniconda ]; then
    miniconda_script="Miniconda3-latest-Linux-x86_64.sh"
    curl https://repo.anaconda.com/miniconda/$miniconda_script -o ~/$miniconda_script
    (cd ~ && echo | bash $miniconda_script -b -p $XDG_DATA_HOME/miniconda)
fi
