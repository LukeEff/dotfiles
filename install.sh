#!/bin/bash
homeFiles=(".bashrc" ".bash_login" ".bash_profile" ".profile" ".bash_login" ".vim" ".gitconfig") 

if [[ "$OSTYPE" == "darwin"* ]]; then

	# Variables
	HOME=/Users/$(whoami)
	DOTFILES=$HOME/dotfiles

	# Install 
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install neovim
	brew install rbenv
	brew install mysql
	brew install maven
	brew install gradle
	brew install docker
	brew install node
	brew install java
	brew install --cask visual-studio-code
	brew install --cask intellij-idea

	for file in ${homeFiles[@]}; do
		rm -rf $HOME/$file
		ln -s $DOTFILES/$file $HOME/$file
	done
	
	# VSCode
	mkdir -p $HOME/Library/Application\ Support/Code/User/
	rm $HOME/Library/Application\ Support/Code/User/settings.json
	rm $HOME/Library/Application\ Support/Code/User/keybindings.json
	ln -s $DOTFILES/.vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
	ln -s $DOTFILES/.vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json

	# Misc.
	rm $HOME/Library/Preferences/com.googlecode.iterm2.plist
	ln -s $DOTFILES/.iterm2/com.googlecode.iterm2.plist $HOME/Library/Preferences/com.googlecode.iterm2.plist

	echo "Installed dotfiles for MacOS."
fi


