#!/bin/bash

# Mac OS
if [[ "$OSTYPE" == "darwin"* ]]; then

	# Variables
	HOME=/Users/$(whoami)
	DOTFILES=$HOME/.dotfiles

	# Install 
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install neovim
	brew install --cask visual-studio-code
	brew install --cask intellij-idea

	# Bash configuration 
	ln -s $DOTFILES/.bashrc $HOME/.bashrc
	ln -s $DOTFILES/.bash_login $HOME/.bash_login
	ln -s $DOTFILES/.bash_profile $HOME/.bash_profile
	ln -s $DOTFILES/.profile $HOME/.profile
	ln -s $DOTFILES/.bash_login $HOME/.bash_login

	# VSCode
	ln -s $DOTFILES/.vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
	ln -s $DOTFILES/.vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json

	# Misc.
	ln -s $DOTFILES/.vim $HOME/.vim
	ln -s $DOTFILES/.gitconfig $HOME/.gitconfig
	ln -s $DOTFILES/.iterm2/plist $HOME/Library/Preferences/com.googlecode.iterm2.plist/

	echo "Installed dotfiles for MacOS."
fi

# Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt install neovim
	
	sudo cp -r .themes/* /usr/share/themes/
	sudo cp -r .icons/* /usr/share/icons/
	gsettings set org.gnome.desktop.interface icon-theme "Simply-Green-Circles"
	gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
	gsettings set org.gnome.desktop.background picture-uri file:///home/$(whoami)/dotfiles/.linux/background.jpg
	sudo apt install gnome-tweaks
	sudo apt install gnome-shell-extensions
	
	echo "Installed dotfiles for linux." 
fi
