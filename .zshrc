# Terminal art
rustmon print --hide-name --name random

# Plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d $ZINIT_HOME ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-auto-notify

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

autoload -U select-word-style
select-word-style bash

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTDUPE=erase

# zsh options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Envs
export EDITOR=nvim
export PATH=/home/vernette/.local/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/vernette/.cargo/bin
export GPG_TTY=$(tty)
export WAYLAND_DISPLAY=wayland-1
export AUTO_NOTIFY_THRESHOLD=20
export AUTO_NOTIFY_TITLE="Hey! '%command' has just finished"
export AUTO_NOTIFY_BODY="It completed in %elapsed seconds"

# Aliases
alias lf="lfrun"
alias ls='lsd --tree --depth 1 --group-dirs=first'
alias lsr='lsd --recursive --depth 1 --group-dirs=first'
alias cd="zcd"
alias v="nvim"
alias cat="bat --theme base16"
alias bt="btop"
alias catnip="catnip --device alsa_output.pci-0000_00_1f.3.analog-stereo --fps 60 --dont-normalize"
alias dil="docker images"
alias dcl="docker container ls -a"
alias gc="git clone"
alias upgr="sudo pacman -Syyu"
alias aupgr="paru -Sua"
alias pinst="pip install"
alias plist="pip list"
alias zshconf="$EDITOR ~/.zshrc && source ~/.zshrc"

# Completion styling
zstyle ':completion:*' matcher-list \
    'm:{[:lower:]}={[:upper:]}' \
    'l:|=* r:|=*' \
    'r:|=*'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:*:*:*:files' ignored-patterns ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:zcd:*' fzf-preview 'lsd --color=always --icon=always $realpath'

# Functions
function zcd() {
  z "$@"
  if [[ -z "$VIRTUAL_ENV" ]] ; then
    # If env folder is found, activate the virtualenv
    if [[ -d ./venv ]] ; then
      source ./venv/bin/activate
    elif [[ -d ./.venv ]] ; then
      source ./.venv/bin/activate
    fi
  else
    # Check if the current folder belongs to the earlier VIRTUAL_ENV folder
    # If not, deactivate the virtual environment
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]] ; then
      deactivate
    fi
  fi
}

ddac() {
    docker rm -vf $(docker ps -aq)
}

ddai() {
    docker rmi -f $(docker images -aq)
}

# Shell integrations
eval "$(fzf --zsh)"

# Zoxide
eval "$(zoxide init zsh)"

eval "$(starship init zsh)"
