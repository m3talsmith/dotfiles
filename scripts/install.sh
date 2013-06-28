echo "Cloning .dotfiles ..."
hash git >/dev/null && /usr/bin/env git clone https://github.com/m3talsmith/dotfiles.git ~/.dotfiles || {
  echo "git not installed"
  exit
}

echo "Backing up current .dotfiles ..."
mkdir ~/.dotfiles/backups
if [ -f ~/.pryrc ] || [ -h ~/.pryrc ]
then
  mv ~/.pryrc ~/.dotfiles/backups/
fi
if [ -f ~/.rvmrc ] || [ -h ~/.rvmrc ]
then
  mv ~/.rvmrc ~/.dotfiles/backups/
fi
if [ -f ~/.screenrc ] || [ -h ~/.screenrc ]
then
  mv ~/.screenrc ~/.dotfiles/backups/
fi
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]
then
  mv ~/.vimrc ~/.dotfiles/backups/
fi
if [ -f ~/.vim ] || [ -h ~/.vim ]
then
  mv ~/.vim ~/.dotfiles/backups/
fi
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
then
  mv ~/.zshrc ~/.dotfiles/backups/
fi

echo "Linking .dotfiles ..."
ln -s ~/.dotfiles/.pryrc ~/.pryrc
ln -s ~/.dotfiles/.rvmrc ~/.rvmrc
ln -s ~/.dotfiles/.screenrc ~/.screenrc
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.zshrc ~/.zshrc

echo "To finalize the configuration changes you need to run:"
echo "  source ~/.zshrc"
echo "Good to go!"
