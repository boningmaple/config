# Alias
# Make the default `ls` output colorful
alias ls='ls --color=auto'
# Same as `ls`, but with file type indicators
alias l='ls -CF --color=auto'
# List all files
alias la='ls -A --color=auto'
# List all files with details
alias ll='ls -alF --color=auto'

# Vi mode
bindkey -v

# History
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Load completions
autoload -Uz compinit && compinit

# Activate Zsh plugins
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
