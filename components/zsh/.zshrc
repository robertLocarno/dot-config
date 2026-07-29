#################
### VARIABLES ###
#################

export EDITOR='nvim'
export VISUAL='nvim'

DOT_CONFIG_DIR="${${(%):-%x}:A:h:h:h}"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# ZSH config
export ZSH="$DOT_CONFIG_DIR/external/oh-my-zsh"
export ZSH_CUSTOM="$DOT_CONFIG_DIR/components/zsh/omz-custom"
export ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
ZSH_THEME="black-tower"
COMPLETION_WAITING_DOTS="%F{yellow}...%f"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
	git
)

#############
### SETUP ###
#############

mkdir -p "$ZSH_CACHE_DIR"

# Make sure the submodule for oh-my-zsh was pulled down
if [[ ! -d "$ZSH" ]]; then
	echo "oh-my-zsh submodule missing at $ZSH" >&2
	echo "Run: git -C $DOT_CONFIG_DIR submodule update --init --recursive" >&2
	return 1
fi

zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':omz:update' mode reminder # can also be 'disabled' or 'auto'

source "$ZSH/oh-my-zsh.sh"

###################
### USER CONFIG ###
###################

# Switches zsh's line editor from emacs-style keybindings to vi-style
bindkey -v

