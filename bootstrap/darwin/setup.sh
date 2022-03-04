#!/usr/bin/env bash
set -euxo pipefail # -e=-o errexit, -u=-o nounset

# Ask for the administrator password upfront
sudo -n true 2>/dev/null || sudo -v
# Keep-alive: update existing `sudo` time stamp until `init.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prevent sleeping during script execution, as long as the machine is on AC power
caffeinate -s -w $$ &

# install homebrew
[[ command -v brew >/dev/null ]] || \
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash

# install apps from Brewfile
brew bundle -v --no-lock || true

### TODO
