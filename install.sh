#!/bin/bash
homeFiles=(".bashrc" ".bash_login" ".bash_profile" ".profile" ".bash_login" ".vim" ".gitconfig") 

if [[ "$OSTYPE" == "darwin"* ]]; then

	# Variables
	HOME=/Users/$(whoami)
	DOTFILES=$HOME/dotfiles

	# Install 
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	sudo chown -R $(whoami) /usr/local/Homebrew
	chmod u+w /usr/local/Homebrew
	brew install neovim
	brew install rbenv
	brew install mysql
	brew install maven
	brew install gradle
	brew install docker
	brew install node
	brew install java
	brew install firefox
	brew install mas
	brew install --cask slack
	brew install --cask zoom
	brew install --cask visual-studio-code
	brew install --cask intellij-idea

	for file in ${homeFiles[@]}; do
		rm -rf $HOME/$file
		ln -s $DOTFILES/$file $HOME/$file
	done

	# Preferences
	defaults write com.apple.finder AppleShowAllFiles TRUE
	defaults write com.apple.dock orientation left 
	defaults write com.apple.dock tilesize 65
	defaults write com.apple.dock autohide 1
	defaults write com.apple.dock largesize 128
	killall Finder
	killall Dock
	
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


