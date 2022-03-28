#!/bin/zsh

##
# History settings
#
# Always set these first, so history is preserved, no matter what happens.
#

#
# znap clean && trs $XDG_CACHE_HOME/zsh-snap/eval/* to get a clean start
#

# Tell zsh where to store history.
# $VENDOR and $OSTYPE let us check what kind of machine we're on.
if [[ $VENDOR == apple ]]; then
  # On macOS, store it in iCloud, so it syncs across multiple Macs.
  HISTFILE=~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Share/zsh_history
else
  HISTFILE=${XDG_DATA_HOME:=~/.local/share}/zsh/history
fi

# Just in case: If the parent directory doesn't exist, create it.
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h

# Max number of entries to keep in history file.
SAVEHIST=$(( 100 * 1000 ))      # Use multiplication for readability.
# Max number of history entries to keep in memory.
HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

##
# History opts
#
# share_history           Auto-sync history between concurrent sessions.
# extended_history        Save each command’s beginning timestamp (in seconds since the epoch)
#                         and the duration (in seconds) to the history file. (! covered by share_history)
# hist_fcntl_lock         Use modern file-locking mechanisms, for better safety & performance.
# hist_ignore_all_dups    Keep only the most recent copy of each duplicate entry in history.
# hist_expire_dups_first  Remove the oldest history event that has a duplicate to be lost before losing a unique event from the list.
# hist_ignore_space       Not adding command lines with the first character on the line being a space.
# hist_verify             Perform history expansion and reload the line into the editing buffer.
setopt share_history hist_fcntl_lock hist_ignore_all_dups \
       hist_expire_dups_first hist_ignore_space hist_verify


zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}
  [[ ${#line} -ge 5
     && ${cmd} != (rm|\\rm|\"rm\")
  ]]
}
