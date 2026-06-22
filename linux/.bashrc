[[ $- != *i* ]] && return

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.node/current/bin"

export GOPATH=$HOME/.go
export PATH="$PATH:$GOPATH/bin"

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

export HF_HOME="$HOME/.llama/models"
export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1

HISTFILE=$HOME/.bash_history      
SAVEHIST=1000                        
HISTSIZE=999                      
export HISTCONTROL=ignoredups:erasedups 
shopt -s histappend
PROMPT_COMMAND="history -a; history -n"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

bind '"\C-f": "~/.dotfiles/.local/bin/tmux-session.sh\n"'

alias ls='ls --color=auto'
alias grep='rg --color=auto'
alias vim='nvim'

eval "$(fzf --bash)"
eval "$(starship init bash)"
