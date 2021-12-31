cp .bashrc ~/.bashrc
cp .bash_login ~/.bash_login
cp .bash_profile ~/.bash_profile
cp .profile ~/.profile
cp .gitconfig ~/.gitconfig
cp -r .vim ~/.vim

# Mac OS

if [[ "$OSTYPE" == "darwin"* ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install neovim
	cp .iterm2/plist ~/Library/Preferences/com.googlecode.iterm2.plist	
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
