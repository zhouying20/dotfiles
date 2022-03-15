#!/usr/bin/env bash
set -euxo pipefail # -e=-o errexit, -u=-o nounset

# Install linuxbrew
if [ ! -d $XDG_DATA_HOME/linuxbrew ]; then
    git clone https://github.com/Homebrew/brew $XDG_DATA_HOME/linuxbrew
fi
eval $($XDG_DATA_HOME/linuxbrew/bin/brew shellenv)

# Install all dependencies from the Brewfile
brew bundle -v --no-lock || true

# Install miniconda
if [ ! -d $XDG_DATA_HOME/miniconda ]; then
    miniconda_script="Miniconda3-latest-Linux-x86_64.sh"
    curl https://repo.anaconda.com/miniconda/$miniconda_script -o ~/$miniconda_script
    (cd ~ && echo | bash $miniconda_script -b -p $XDG_DATA_HOME/miniconda)
fi
