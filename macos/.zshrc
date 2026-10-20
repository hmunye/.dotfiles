export GOPATH=$HOME/.go
export PATH="$PATH:$GOPATH/bin"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.node/current/bin"
export PATH="$PATH:/opt/homebrew/opt/rustup/bin"

export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_AUTO_UPDATE=1

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

bindkey -s '^f' '^u~/.local/bin/tmux-session.sh^M'

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
alias vim='nvim'
alias python='python3'
# alias gcc='gcc-14'

source <(fzf --zsh) && eval "$(starship init zsh)"
