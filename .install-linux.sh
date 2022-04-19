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
