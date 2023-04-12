##
# Plugins
#

# Add the plugins you want to use here.
# For more info on each plugin, visit its repo at github.com/<plugin>
# -a sets the variable's type to array.
local -a plugins=(
  zsh-users/zsh-completions           # Additional completion definitions
  zsh-users/zsh-autosuggestions       # Inline suggestions
  zsh-users/zsh-syntax-highlighting   # Command-line syntax highlighting
  marlonrichert/zsh-autocomplete      # Real-time type-ahead completion, set zcompdump to $XDG_CACHE_HOME/zsh
  marlonrichert/zsh-edit              # Better keyboard shortcuts
  marlonrichert/zsh-hist              # Edit history from the command line.
  marlonrichert/zcolors               # Colors for completions and Git
  esc/conda-zsh-completion            # ZSH completion for conda
  le0me55i/zsh-extract
)

# Speed up the first startup by cloning all plugins in parallel.
# This won't clone plugins that we already have.
znap clone $plugins

# Load each plugin, one at a time.
local p=
for p in $plugins; do
  znap source $p
done

# `znap eval <name> '<command>'` is like `eval "$( <command> )"` but with
# caching and compilation of <command>'s output, making it ~10 times faster.
# znap eval zcolors zcolors   # Extra init code needed for zcolors.
# znap eval zcolors "zcolors ${(q)LS_COLORS}"

# Configure plugins after installed them
# The Zsh Autocomplete plugin sends *a lot* of characters to your terminal.
# This is fine locally on modern machines, but if you're working through a slow
# ssh connection, you might want to add a slight delay before the
# autocompletion kicks in:
#   zstyle ':autocomplete:*' min-delay 0.5  # seconds
#
# If your connection is VERY slow, then you might want to disable
# autocompletion completely and use only tab completion instead:
#   zstyle ':autocomplete:*' async no
zstyle ':autocomplete:*' min-input 2
zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' fzf-completion yes
zstyle -e ':autocomplete:*' list-lines 'reply=( $(( LINES / 2 )) )'
zstyle ':completion:*' file-sort date
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:paths' path-completion yes
zstyle ':completion:*:processes' command 'ps -afu $USER'
zstyle ':znap:*:*' git-maintenance off

bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
# bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect '\r' .accept-line
# unset <-, -> in menuselect
bindkey -M menuselect '\e[D' .backward-char
bindkey -M menuselect '\eOD' .backward-char
bindkey -M menuselect '\e[C' .forward-char
bindkey -M menuselect '\eOC' .forward-char

+autocomplete:recent-directories() {
  reply=( ${(f)"$( zoxide query --list $1 2> /dev/null )"} )
}

# Load some plugins from oh-my-zsh
znap source ohmyzsh/ohmyzsh plugins/vscode

# iterm2_shell_integration
if [ "${LC_TERMINAL-}" = "iTerm2" ]; then
  path=( $path $HOME/.local/bin/iterm2 )
  znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'
fi

# zoxide, must be added after compinit is called
(( $+commands[zoxide] )) && znap eval zoxide 'zoxide init zsh'

# direnv
# (( $+commands[direnv] )) && znap eval direnv "$(readlink -f $commands[direnv]) hook zsh"
