[[ "$(tty)" == "/dev/tty1" ]] && start-hyprland

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
