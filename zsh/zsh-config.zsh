# Vi mode
bindkey -v

# Load completion and styling
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu

# Opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt no_case_glob no_case_match
setopt interactive_comments

# Aliases
# List all files
alias la='ls -AFG'
# List all files with details
alias l='ls -AFGlh'
alias vim='/usr/local/bin/vim'
alias v = 'vim'

# Activate Zsh plugins
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Fzf config
export FZF_DEFAULT_OPTS='--no-height --no-reverse'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Rust
export PATH="$(brew --prefix rustup)/bin:$PATH"

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

