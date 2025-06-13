[[ $- != *i* ]] && return

export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

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
alias grep='grep --color=auto'
alias vim='nvim'

eval "$(fzf --bash)"
eval "$(starship init bash)"
