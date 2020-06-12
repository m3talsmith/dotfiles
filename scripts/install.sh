stamp=$(date +"%s")
stampDir=$(date +"%Y/%m/%d")

if [ -d ~/.dotfiles ]
then
  echo "Backing up current .dotfiles ..."
  mv ~/.dotfiles ~/.dotfiles_${stamp}.bak
fi

echo "Cloning .dotfiles ..."
hash git >/dev/null && /usr/bin/env git clone https://github.com/m3talsmith/dotfiles.git ~/.dotfiles || {
  echo "git not installed"
  exit
}

baseDir=${HOME}/.dotfiles
backupDir=${baseDir}/backups
currentBackupDir=${backupDir}/${stampDir}
mkdir -p ${currentBackupDir}
backupFiles=( .pryrc .screenrc .vimrc .vim .zshrc .gitconfig )

if [ -d ${HOME}/.oh-my-zsh ]
then
  echo "Reinstalling oh-my-zsh ..."
  rm  -rf ${HOME}/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  source ${HOME}/.zshrc
  echo "Installing spaceship ..."
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

for file in ${backupFiles[@]}
do
  if [ -f ${HOME}/${file} ] || [ -d ${HOME}/${file} ]
  then
    echo "Backing up $file ..."
    mv ${HOME}/${file} ${currentBackupDir}/${file}
  fi
  if [ -h ${HOME}/${file} ]
  then
    echo "Removing old symlink for $file ..."
    rm -f ${HOME}/${file} 
  fi
  echo "Creating symlink for $file ..."
  ln -s ${baseDir}/${file} ${HOME}/${file}
done

echo "To finalize the configuration changes you may need to run:"
echo "  source ~/.zshrc"
echo "Good to go!"
