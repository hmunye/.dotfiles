[[ $- != *i* ]] && return

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.go/bin"
export PATH="$PATH:$HOME/.node/current/bin"

export GOPATH="$HOME/.go/"

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

bind '"\C-f": "~/.dotfiles/.local/bin/tmux-session.sh\n"'

HISTFILE=$HOME/.bash_history      
SAVEHIST=1000                        
HISTSIZE=999                      
export HISTCONTROL=ignoredups:erasedups 
shopt -s histappend
PROMPT_COMMAND="history -a; history -n"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias ls='ls --color=auto'
alias grep='rg --color=always'
alias vim='nvim'

eval "$(fzf --bash)"
eval "$(starship init bash)"
