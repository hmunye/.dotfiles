export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

export PATH="$HOME/.docker/bin:$PATH"

export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_AUTO_UPDATE=1
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

export CC=gcc-14

bindkey -s '^f' '^u~/.dotfiles/.local/bin/tmux-session.sh^M'

HISTFILE=$HOME/.zsh_history
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gcc='gcc-14'
alias vim='nvim'
alias python='python3'

source <(fzf --zsh)
eval "$(starship init zsh)"
