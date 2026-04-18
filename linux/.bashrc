[[ $- != *i* ]] && return

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

export OLLAMA_NO_CLOUD=1
export OLLAMA_KV_CACHE_TYPE=q4_0
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_CONTEXT_LENGTH=16834

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
alias grep='rg --color=always'
alias vim='nvim'

eval "$(fzf --bash)"
eval "$(starship init bash)"
