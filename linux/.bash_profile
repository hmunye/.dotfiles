[[ "$(tty)" == "/dev/tty1" ]] && exec sway --unsupported-gpu

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
