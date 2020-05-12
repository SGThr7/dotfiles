# Remove duplicates 
typeset -U path PATH

# alias
alias relogin="exec $SHELL -l"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias kill-mosh='kill `pidof mosh-server`'

# color setting
autoload -Uz colors
colors

PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

# history setting
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# words separator
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# nvm setting
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

########################################
# suggestion
autoload -Uz compinit
compinit

# ignore cases
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' ignore-parents parent pwd ..

zstyle ':completion::complete:*' use-cache true

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

zstyle ':completion:*' menu select

zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
########################################
# ls colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=32:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias ls="ls -F --color"
alias gls="gls --color"

zstyle ':completion:*' list-colors "${LS_COLORS}"

########################################
# options

# hidden pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# set to display asian characters
setopt print_eight_bit

setopt no_beep

setopt no_flow_control

# Ctrl+D will not exit
setopt ignore_eof

# set comment character '#'
setopt interactive_comments

# ommit 'cd'
setopt auto_cd
# auto ls
function chpwd() { ls }

# auto pushd
setopt auto_pushd
setopt pushd_ignore_dups

setopt share_history

setopt hist_ignore_all_dups

setopt hist_ignore_space

setopt hist_reduce_blanks

# advanced wild card
setopt extended_glob
########################################
# User functions
function mcd() {
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}

########################################
# vcs_info
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
