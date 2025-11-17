eval "$(zoxide init bash)"

source /usr/share/nvm/init-nvm.sh

export EDITOR="code"
export MOZ_ENABLE_WAYLAND=1
export PATH="$PATH:/home/cekita/.cargo/bin"

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

wallpaper() {
  echo "loadfile $1" | socat - /tmp/mpv-socket
}

GREEN='\[\e[32m\]'
CYAN='\[\e[36m\]'
YELLOW='\[\e[33m\]'
RED='\[\e[31m\]'
MAGENTA='\[\e[35m\]'
RESET='\[\e[0m\]'
NEWLINE=$'\n'

export PS1="${GREEN}\u@\h ${CYAN}\w ${YELLOW}\t ${RED}\$(format_current_git_branch)${NEWLINE}${MAGENTA}\\\$ ${RESET}"
export PATH=/home/cekita/.local/bin:/home/cekita/.nvm/versions/node/v22.0.0/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/cekita/.cargo/bin:/home/cekita/.local/share/JetBrains/Toolbox/scripts:/home/cekita/.cargo/bin
