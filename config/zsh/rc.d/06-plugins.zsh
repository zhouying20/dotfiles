##
# Plugins
#

# Add the plugins you want to use here.
# For more info on each plugin, visit its repo at github.com/<plugin>
# -a sets the variable's type to array.
local -a plugins=(
  le0me55i/zsh-extract
  esc/conda-zsh-completion            # ZSH completion for conda
  zsh-users/zsh-completions           # Additional completion definitions
  zsh-users/zsh-autosuggestions       # Inline suggestions
  zsh-users/zsh-syntax-highlighting   # Command-line syntax highlighting
  marlonrichert/zsh-autocomplete      # Real-time type-ahead completion, set zcompdump to $XDG_CACHE_HOME/zsh
  marlonrichert/zsh-hist              # Edit history from the command line.
  marlonrichert/zsh-edit              # Better keyboard shortcuts
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

# Plugins configuration
zstyle ':znap:*:*' git-maintenance off

# If your connection is VERY slow, then you might want to disable
# autocompletion completely and use only tab completion instead:
# zstyle ':autocomplete:*' async no
zstyle ':autocomplete:*' min-input 2
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
zstyle ':autocomplete:*' timeout 2.0  # seconds (float)
# Note: -e lets you specify a dynamically generated value.
zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 2 )) )'

zstyle ':completion:*' expand no
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' file-sort date
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:paths' path-completion yes
zstyle ':completion:*:processes' command 'ps -afu $USER'

# Make Tab and ShiftTab cycle completions on the command line
# -> use 'menu-select' to iter menu
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# Make Tab and ShiftTab change the selection in the menu instead of Exit Tab selection
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

# Make Enter always submit the command line
bindkey -M menuselect '\r' .accept-line

# unset <-, -> in menuselect
bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
bindkey -M menuselect '^[[C' .forward-char '^[OC' .forward-char

# Load some plugins from oh-my-zsh
# znap source ohmyzsh/ohmyzsh plugins/vscode

# iterm2_shell_integration
if [ "${LC_TERMINAL-}" = "iTerm2" ]; then
  path=( $path $HOME/.local/bin/iterm2 )
  znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'
fi