if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi


# Added by Toolbox App
export PATH="$PATH:/home/cekita/.local/share/JetBrains/Toolbox/scripts"

