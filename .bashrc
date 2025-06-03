eval "$(zoxide init bash)"

source /usr/share/nvm/init-nvm.sh

export EDITOR="code"
PATH=$PATH:$HOME/Downloads/flutter/bin

alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
alias y='yazi'
alias q='exit'
alias tws='bluetoothctl connect $(bluetoothctl devices | grep "TWS" | sed -E "s/Device (\\S+) TWS200/\\1/")'

format_current_git_branch() {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -n $BRANCH ]]; then
    echo "(${BRANCH})"
  fi
}

GREEN='\[\e[32m\]'
CYAN='\[\e[36m\]'
YELLOW='\[\e[33m\]'
RED='\[\e[31m\]'
MAGENTA='\[\e[35m\]'
RESET='\[\e[0m\]'
NEWLINE=$'\n'

export PS1="${GREEN}\u@\h ${CYAN}\w ${YELLOW}\t ${RED}\$(format_current_git_branch)${NEWLINE}${MAGENTA}\\\$ ${RESET}"
