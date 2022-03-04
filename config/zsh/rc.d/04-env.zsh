#!/bin/zsh

##
# Environment variables
#

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# -U ensures each entry in these is Unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.
# export MANPATH=$HOME/.local/share/man:/usr/local/share/man:/usr/share/man
# export INFOPATH=$HOME/.local/share/info:/usr/local/share/info:/usr/share/info


# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
path=(
    /home/linuxbrew/.linuxbrew/bin(N)
    $XDG_DATA_HOME/linuxbrew/bin(N)   # (N): null if file doesn't exist
    $path
    ~/.local/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin:/sbin
)

# Add your functions to your $fpath, so you can autoload them.
fpath=(
    $ZDOTDIR/functions
    $fpath
    ~/.local/share/zsh/site-functions
)

local OS=$(uname -s | tr A-Z a-z)
case $OS in
  ( darwin )
    export SHELL_SESSIONS_DISABLE=1

    for pkg in "coreutils" "findutils" "gnu-sed" "gnu-tar" "grep"; do
        # BSD flavour -> GNU flavour
        path=( /usr/local/opt/$pkg/libexec/gnubin $path)
    done

    export CONDA_HOME=/usr/local/Caskroom/miniconda/base
    path=(
      $CONDA_HOME/bin
      $path
      /Library/TeX/texbin
      /Library/Apple/usr/bin
    )
  ;;
  ( linux )
    export DEBIAN_PREVENT_KEYBOARD_CHANGES=1
    export skip_global_compinit=1
    export LANGUAGE=en

    # export NPM_CONFIG_PREFIX=$HOME/.local ubuntu

    # [ -d /home/linuxbrew/.linuxbrew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    # [ -d $XDG_DATA_HOME/linuxbrew ] && eval $($XDG_DATA_HOME/linuxbrew/bin/brew shellenv)

    export CONDA_HOME=$XDG_DATA_HOME/miniconda
    path=(
      $CONDA_HOME/bin
      $path
    )
  ;;
esac

if command -v brew > /dev/null; then
  # `znap eval <name> '<command>'` is like `eval "$( <command> )"` but with
  # caching and compilation of <command>'s output, making it 10 times faster.
  znap eval brew-shellenv 'brew shellenv'

  # Add dirs containing completion functions to your $fpath and they will be
  # picked up automatically when the completion is initialized.
  # Here, we add it to the end of $fpath, so that we use brew's completions
  # only for those commands that zsh doesn't already know how to complete.
  fpath+=( $HOMEBREW_PREFIX/share/zsh/site-functions )
fi

export CONDARC=$XDG_CONFIG_HOME/conda/condarc
# export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
# export GNUPGHOME=$XDG_CONFIG_HOME/gnupg
# export IPYTHONDIR=$XDG_CONFIG_HOME/ipython
# export JUPYTER_CONFIG_DIR=$XDG_CONFIG_HOME/jupyter
# export MACHINE_STORAGE_PATH=$XDG_DATA_HOME/docker-machine
# export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
# export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
export VIMINIT="set nocp | source $XDG_CONFIG_HOME/vim/vimrc"
