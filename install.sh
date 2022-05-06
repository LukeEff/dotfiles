#!/bin/bash
homeFiles=(".bashrc" ".bash_login" ".bash_profile" ".profile" ".bash_login" ".vim" ".gitconfig") 

# Update all Wallpapers
function wallpaper() {
    sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$1'" && killall Dock 
}

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

	# Install from app store
	mas install 441258766 # Magnet
	mas install 497799835 # Xcode
	mas upgrade 

	for file in ${homeFiles[@]}; do
		rm -rf $HOME/$file
		ln -s $DOTFILES/$file $HOME/$file
	done

	# Vim config
	mkdir -p $HOME/.config/nvim
	ln -s $DOTFILES/.vim/vimrc $HOME/.config/nvim/vimrc
	ln -s $DOTFILES/.vim/utils.vim $HOME/.config/nvim/utils.vim
	ln -s $DOTFILES/.vim/init.vim $HOME/.config/nvim/init.vim

	# Preferences
	defaults write com.apple.LaunchServices "LSQuarantine" -bool "false" 

	wallpaper ~/dotfiles/.linux/background.jpg
	defaults write com.apple.finder AppleShowAllFiles -bool true 
	defaults write com.apple.finder AppleShowAllExtensions -bool true
	defaults write com.apple.finder WarnOnEmptyTrash -bool false
	defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"

	defaults write com.apple.dock "show-recents" -bool "false"
	defaults write com.apple.dock "mineffect" -string "suck"
	defaults write com.apple.dock orientation left 
	defaults write com.apple.dock tilesize -int 65
	defaults write com.apple.dock autohide -int 1
	defaults write com.apple.dock largesize -int 128

	defaults write -globalDomain AppleInterfaceStyle Dark
	killall Finder
	killall Dock
	sudo killall -HUP WindowServer
	
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


