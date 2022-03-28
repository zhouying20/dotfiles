#!/bin/zsh

##
# Named directories
#
# Set these early, because it affects how dirs are displayed and printed.
#

# Create shortcuts for your favorite directories.
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
hash -d d="$HOME/.dotfiles"
hash -d z=$ZDOTDIR
hash -d zp=$znap_dir
if [[ $VENDOR == apple ]]; then
  hash -d icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  hash -d clash="$HOME/Library/Mobile Documents/iCloud~com~west2online~ClashX/Documents"
fi

# Change dirs without `cd`. Just type the dir and press enter.
# NOTE: This will misfire if there is an alias, function, builtin or command
# with the same name!
# To be safe, use autocd only with paths starting with .. or / or ~ (including
# named directories).
setopt AUTO_CD
