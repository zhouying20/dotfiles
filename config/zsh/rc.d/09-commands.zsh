#!/bin/zsh

##
# Commands, funtions and aliases
#
# Always set aliases _last,_ so they don't class with function definitions.
#

# Note that, unlike Bash, there's no need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.

# Type '-' to return to your previous dir.
alias -- -='cd -'
# '--' signifies the end of options. Otherwise, '-=...' would be interpreted as
# a flag.

# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=

# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'

alias cp='cp -i'
alias mv='mv -i'
alias df='df -hT'

alias ...='cd ../..'
alias ....='cd ../../..'

# GNU flavour alias
alias ls="ls --color=auto"
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lAh'
alias grep="grep --color=auto"

# Tmux alias
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
# alias tmuxconf='$EDITOR $ZSH_TMUX_CONFIG'

# Set $PAGER if it hasn't been set yet. We need it below.
# `:` is a builtin command that does nothing. We use it here to stop Zsh from
# evaluating the value of our $expansion as a command.
: ${PAGER:=less}

# Associate file .extensions with programs.
# This lets you open a file just by typing its name and pressing enter.
# Note that the dot is implicit. So, `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'

# Use `< file` to quickly view the contents of any file.
READNULLCMD=$PAGER  # Set the program to use for this.

# Quick functions
alias paths='echo -e ${PATH//:/\\n}'
alias fpaths='echo -e ${FPATH//:/\\n}'
alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
if [[ $VENDOR == apple ]]; then
  alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"
  alias cleanupad="find . -type d -name '.AppleD*' -ls -exec /bin/rm -r {} \;"
fi

# Disable rm
alias rm='echo "This is not the command you are looking for."; false'
# ts already set for tmux
trs () {
  if ! command -v trash > /dev/null; then
    echo "Neither trash (https://hasseg.org/trash/) or trash-cli (https://github.com/andreafrancia/trash-cli) installed."
    return false
  fi

  if [[ $VENDOR == apple ]]; then
    trash -F "$@"
  else
    trash-put "$@"
  fi
}

# Lazy load conda
conda () {
  unfunction conda

  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$("$CONDA_HOME/bin/conda" "shell.zsh" "hook" 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
      . "$CONDA_HOME/etc/profile.d/conda.sh"
    else
      export PATH="$CONDA_HOME/bin:$PATH"
    fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

  conda "$@"
}
# conda activate &> /dev/null

# Determine size of a file or total size of a directory
fs () {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi

  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* *
  fi
}

# add $(pwd) to PYTHONPATH
ppwd () {
  if [[ -z "$PYTHONPATH" ]]; then
    export PYTHONPATH=$(pwd)
  else
    export PYTHONPATH=$(pwd):$PYTHONPATH
  fi
}
pclr() {
  unset PYTHONPATH
}

proxy () {
  local p_server=${1:-127.0.0.1}
  local p_port=${2:-18123}
  export http_proxy=http://$p_server:$p_port
  export https_proxy=http://$p_server:$p_port
  export all_proxy=socks5://$p_server:$p_port
  export no_proxy='localhost,127.0.0.0/8,*.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12'
  echo "Proxy on"
}
noproxy () {
  unset http_proxy
  unset https_proxy
  unset all_proxy
  unset no_proxy
  echo "Proxy off"
}
# local proxy_port=18123
# if lsof -Pi:$proxy_port -sTCP:LISTEN > /dev/null; then # check if proxy port opened
#   proxy &> /dev/null
# fi
if nc -z -w 2 127.0.0.1 18123 > /dev/null 2>&1; then # prefer to local
  proxy &> /dev/null
elif nc -z -w 2 192.168.14.70 7890 > /dev/null 2>&1; then
  proxy 192.168.14.70 7890 &> /dev/null
fi
