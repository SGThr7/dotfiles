export ZDOTDIR="${HOME}"
export ZSHRC="${ZDOTDIR}/.zshrc"
export ZSHENV="${ZDOTDIR}/.zshenv"
export ZPROFILE="${ZDOTDIR}/.zprofile"
export VIMRC="${HOME}/.vimrc"
export VDOTDIR="${HOME}/.vim"
export GITIGNORE="${HOME}/.config/git/ignore"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fpath=(~/.zsh/completion $fpath)

if type pyenv>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi
source "$HOME/.cargo/env"
