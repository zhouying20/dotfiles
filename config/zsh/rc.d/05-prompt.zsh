#!/bin/zsh


##
# Main prompt
#

# Lazy-load hook functions from file.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
# -U tells autoload not to expand aliases inside the function.
# -z tells autoload that the function file is written in the default Zsh style.
# The latter is normally not necessary, but better safe than sorry.
#
# We can autoload these functions by just their name, rather than by path,
# because in 04-env.zsh, we added their parent dir to our $fpath.
#
# autoload -Uz add-zsh-hook precmd

# `znap prompt` can autoload our prompt function, because in 04-env.zsh, we
# added its parent dir to our $fpath.
# chpwd: Whenever we change dirs, prompt the new directory.
# znap prompt launchpad
# chpwd  # Call once before the first prompt.

# Reduce startup time by making the left side of the primary prompt visible
# *immediately.*
# starship
(( $+commands[starship] )) && znap eval starship 'starship init zsh --print-full-init'
# znap prompt starship

# Auto-remove the right side of the prompt when you press enter.
# That way, we'll have less clutter on screen.
# It also makes it easier to copy code from our terminal.
setopt TRANSIENT_RPROMPT

# If we're not on an SSH connection, then remove the outer margin of the right
# side of the prompt.
[[ -v SSH_CONNECTION ]] ||
    ZLE_RPROMPT_INDENT=0

## dir_colors
# export LSCOLORS=Gxfxcxdxbxegedabagacad
# export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"
# export LS_COLORS="$(vivid generate dracula)"
(( $+commands[dircolors] )) && znap eval dircolors 'dircolors -b $ZDOTDIR/LS_COLORS'
