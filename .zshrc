#!/usr/bin/env zsh

# checks whether the passed in command exists in the path
function is_installed() {
    command -v "$1" > /dev/null 2>&1
}

# set up zinit
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    if ! is_installed "git"; then
        echo "Git is not installed. Could not set up Zinit!"
	exit 1
    fi

    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone "https://github.com/zdharma-continuum/zinit.git" "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# load zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# load completions
autoload -U compinit && compinit

# zsh completion options
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD # TODO: maybe remove?

# zsh history options
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# zsh input and output options
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# shell vim key bindings
bindkey -v

# enable case-insensitive autocompletions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# enable colors when listing files
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 

# initialize and alias zoxide to 'cd' if it is installed
if is_installed "zoxide"; then
    ZOXIDE_COMMAND="${ZOXIDE_COMMAND:-cd}"
    eval "$(zoxide init --cmd $ZOXIDE_COMMAND zsh)"
fi

if ! is_installed "oh-my-posh"; then
    mkdir -p "$HOME/.local/bin"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi

if is_installed "oh-my-posh"; then
    eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/fade.toml")"
    alias omp="oh-my-posh"
fi

# alias nvim to vim, vi and v if it is installed
if is_installed "nvim"; then 
    export EDITOR=nvim
    alias vim=nvim
    alias vi=nvim
    alias v=nvim
fi

# color aliases
alias ls="ls --color"
alias ip"ip --color"
alias diff="diff --color"
alias grep="grep --color"

# quality of life aliases
alias l="ls -lAh"
alias md="mkdir -p"
alias rd="rmdir"

