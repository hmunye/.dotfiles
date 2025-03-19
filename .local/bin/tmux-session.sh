#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Developer -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      tmux new-session -s "$selected_name" -c "$selected"
    else
      tmux new-session -s "$selected_name" -c "$selected" 'bash -i'
    fi

    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      tmux new-session -ds "$selected_name" -c "$selected"
    else
      tmux new-session -ds "$selected_name" -c "$selected" 'bash -i'
    fi
fi

tmux switch-client -t $selected_name
