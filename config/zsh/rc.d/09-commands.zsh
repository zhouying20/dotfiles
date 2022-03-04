#!/bin/zsh

##
# Commands, funtions and aliases
#
# Always set aliases _last,_ so they don't class with function definitions.
#

# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=


# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'

# Note that, unlike Bash, there's no need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.


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


alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -i'
alias df='df -hT'
alias mv='mv -i'
alias ls="ls --color=tty"
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lAh'
alias grep="grep --color=auto"
alias paths='echo -e ${PATH//:/\\n}'
alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias export_proxy='export https_proxy=http://127.0.0.1:18123 http_proxy=http://127.0.0.1:18123 all_proxy=socks5://127.0.0.1:18123'

# disable rm
alias rm='echo "This is not the command you are looking for."; false'
ts () {
  if [[ ! command -v trash > /dev/null]]; then
    echo "Neither trash (https://hasseg.org/trash/) or trash-cli (https://github.com/andreafrancia/trash-cli) installed."
    false
  fi

  if [[ $VENDOR == apple ]]; then
    trash -F "$@"
  else
    trash-put "$@"
  fi
}

# lazy load conda
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