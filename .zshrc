######################################################################
# Zinit installer

# Install zinit if not installed
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
	mkdir -p "$HOME/.zinit" && chmod g-rwX "$HOME/.zinit"
	git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
		print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
	zinit-zsh/z-a-rust \
	zinit-zsh/z-a-readurl \
	zinit-zsh/z-a-patch-dl \
	zinit-zsh/z-a-bin-gem-node 


######################################################################
# Setting by OS

# [ -f $ZDOTDIR/.zshrc-`uname` ] && . $ZDOTDIR/.zshrc-`uname`
case `uname` in
Darwin)
	# homebrew alias
	case `uname -m` in
		x86_64) alias brew="/usr/local/bin/brew";;
		arm64) alias brew="/opt/homebrew/bin/brew";;
	esac
	alias ls="ls -G"
	alias ll="ls -lG"
	alias la="ls -aG"
	alias lla="ls -laG"
	alias lal="ls -laG"
;;
Linux)
	alias ls="ls --color"
	alias ll="ls -l --color"
	alias la="ls -a --color"
	alias lla="ls -la --color"
	alias lal="ls -la --color"
;;
esac


######################################################################
# Completions
autoload -Uz compinit && compinit

# zsh-autocomplete (https://github.com/marlonrichert/zsh-autocomplete)
# Real-time type-ahead autocompletion
zinit lucid for \
	marlonrichert/zsh-autocomplete
# zstyle ':autocomplete:*' min-input 1

# fast-syntax-highlighting (https://github.com/zdharma/fast-syntax-highlighting)
zinit wait lucid for \
	atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
		zdharma/fast-syntax-highlighting \
	atload'!_zsh_autosuggest_start' \
		zsh-users/zsh-autosuggestions

# Generate completions
# * cargo  - rust package manager
# * rustup - rust toolchain installer
zinit atpull'%atclone' for \
	has'rustup' id-as'cargo'  atclone'rustup completions zsh cargo > _cargo' zdharma/null \
	has'rustup' id-as'rustup' atclone'rustup completions zsh > _rustup' zdharma/null

# Download completions
# * docker         - Docker CLI
# * docker-compose - A tool for defining and running multi-container Docker applications
# * exa            - A modern file-listing command
zinit as'completion' atpull'%atclone' for \
	'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
	has'docker-compose' 'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \
	has'exa' 'https://github.com/ogham/exa/blob/master/completions/completions.zsh'

# Additional completions
zinit ice blockf
zinit load zsh-users/zsh-completions

# completion settings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 
zstyle ':completion:*' ignore-parents parent pwd .. 
zstyle ':completion::complete:*' use-cache true 
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin 
zstyle ':completion:*' menu select 
zstyle ':completion:*:processes' command 'ps x -o pid,stat,%cpu,cputime,%mem,command'
ZSH_AUTOSUGGEST_STRATEGY=(completion history)


######################################################################
# Prompt settings

# Color setting
autoload -Uz colors && colors

# Prompt format
PROMPT="%{${fg[green]}%}[%n@%m#`uname -m`]%{${reset_color}%} %~
%# "

# Version-Control-System-Info settings
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats '%F{green}(%m)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%m)-[%b|%a]%f'
zstyle ':vcs_info:git+set-message:*' hooks git-hook-begin git-user

function +vi-git-hook-begin() {
	if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
		return 1
	fi
	return 0
}

function +vi-git-user() {
	if [[ "$1" != "0" ]]; then
		return 0
	fi
	user_name=`git config user.name`
	if [[ -z "$user_name" ]] then
		user_name="guest"
	fi
	hook_com[misc]+=$user_name
}

function _update_vcs_info_msg() {
	LANG=en_US.UTF-8 vcs_info
	RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


######################################################################
# Other Plugins

# zsh-background-notify (https://github.com/t413/zsh-background-notify)
# Notify finished command on background
zinit wait lucid for \
	t413/zsh-background-notify


######################################################################
# Aliases

alias relogin="exec ${SHELL} -l"
alias fig='docker-compose'
alias grep='grep --color=auto'

# -i: interactive
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

function gles {
	grep --directories=skip --line-number --color=always $@ | less -R
} 

if (( $+commands[exa] )) then
	alias ls="exa"
	alias ll="exa -lhG"
	alias la="exa -a"
	alias lla="exa -lhaG"
	alias lal="lla"
fi


######################################################################
# Other settings

# Remove duplicates 
typeset -U path PATH

# Keybinding
bindkey "^j" forward-word
# bindkey "^;" backward-word
bindkey '^]'   vi-find-next-char
bindkey '^[^]' vi-find-prev-char

# history setting
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# words separator
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# ls colors
export LSCOLORS=Gxfxcxdxbxegedabagacad 
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31;04:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' list-colors "${LS_COLORS}"

# auto ls
function chpwd() { ls -a }
setopt auto_cd 
setopt print_eight_bit
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments

setopt auto_pushd
setopt pushd_ignore_dups

setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
