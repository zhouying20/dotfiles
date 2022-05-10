#!/bin/zsh
#
# This file, .zshenv, is the first file sourced by zsh for EACH shell, whether
# it's interactive or not.
# This includes non-interactive sub-shells!
# So, put as little in this file as possible, to avoid performance impact.
#

# Note: The shebang #!/bin/zsh is strictly necessary for executable scripts
# only, but without it, you might not always get correct syntax highlighting
# when viewing the code.

# Tell zsh where to look for our dotfiles.
# By default, Zsh will look for dotfiles in $HOME (and find this file), but
# once $ZDOTDIR is defined, it will start looking in that dir instead.
# ${X:=Y} specifies a default value Y to use for parameter X, if X has not been
# set or is null. This will actually create X, if necessary, and assign the
# value to it.
# To set a default value that is returned *without* setting X, use ${X:-Y}
# As in other shells, ~ expands to $HOME _at the beginning of a value only._

# ${X:=Y} conditionally assign a variable which set X to "Y" if X is not set
# or is empty string.
# : is a colon, the colon is a null command that does nothing and ignores
# its arguments. It is built into bash so a new process is not created.
: ${XDG_CACHE_HOME:=~/.cache}
: ${XDG_CONFIG_HOME:=~/.config}
: ${XDG_DATA_HOME:=~/.local/share}
: ${XDG_STATE_HOME:=~/.local/state}
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

if [[ $VENDOR == apple ]]; then
  export SHELL_SESSIONS_DISABLE=1
fi

ZDOTDIR=${XDG_CONFIG_HOME:=~/.config}/zsh
