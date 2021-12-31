mv .bashrc ~/.bashrc
mv .bash_login ~/.bash_login
mv .bash_profile ~/.bash_profile
mv .profile ~/.profile
mv .gitconfig ~/.gitconfig
mv .vim ~/.vim

# Mac OS

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installed dotfiles for Mac OS."
	mv .iterm2/plist ~/Library/Preferences/com.googlecode.iterm2.plist	
fi

# Linux

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Installed dotfiles for linux." 
fi
