#!/usr/bin/env bash
set -euxo pipefail # -e=-o errexit, -u=-o nounset

# Ask for the administrator password upfront
sudo -n true 2>/dev/null || sudo -v
# Keep-alive: update existing `sudo` time stamp until `init.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prevent sleeping during script execution, as long as the machine is on AC power
caffeinate -s -w $$ &

# install homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install apps from Brewfile
brew bundle -v || true

# iCloud ssh restore
ssh_src="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Share/.ssh/config"
if [[ -f $ssh_src ]]; then
  mkdir -p "${HOME}/.ssh" && ln -sf "${ssh_src}" "${HOME}/.ssh/config"
fi

# Mackup restore
# MACKUP_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Mackup"
# if [[ -f "$MACKUP_DIR/.mackup.cfg" && ! -L "$HOME/.mackup.cfg" ]]; then
#     cp -v  "$MACKUP_DIR/.mackup.cfg" $HOME
#     cp -rv "$MACKUP_DIR/.mackup" $HOME
#     mackup restore -f
# else
#     echo "mackup.cfg does not exist, please perform the recovery manually later."
# fi
