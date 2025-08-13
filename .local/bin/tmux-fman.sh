#!/usr/bin/env bash

dirs="/usr/share/man"

if [[ "$OSTYPE" == "darwin"* ]]; then
  shell="zsh"

  dirs+=" /opt/homebrew/share/man \
  /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/share/man \
  /Library/Developer/CommandLineTools/usr/share/man"
else
  shell="bash"

  dirs+=" /usr/local/man/man8"
fi

tmux neww $shell -c "find -L $dirs -type f | fzf | xargs man"
