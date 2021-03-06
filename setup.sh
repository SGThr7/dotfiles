#!/bin/bash

__DIRNAME=$PWD
dotfiles=($(ls -a $__DIRNAME))
ignorefiles=(setup.sh .git .. .)

# Delete $ignorefiles from $dotfiles
for del in ${ignorefiles[@]}; do
	for i in "${!dotfiles[@]}"; do
		if [[ ${dotfiles[i]} = $del  ]]; then
			unset 'dotfiles[i]'
			break
		fi
	done
done
dotfiles=(${dotfiles[@]})

# Make symbolic link to $HOME
for file in ${dotfiles[@]/$ignorefiles}; do
	if [[ -d $file ]]; then
		ln -vsF $__DIRNAME/$file/ $HOME/$file
	elif [[ -f $file ]]; then
		ln -vsf $__DIRNAME/$file $HOME/$file
	fi
done

echo "Setup have been finished."
exec $SHELL -l
exit 0
