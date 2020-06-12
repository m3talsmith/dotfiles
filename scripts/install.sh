stamp=$(date +"%s")
stampDir=$(date +"%Y/%m/%d")

echo "Backing up current .dotfiles ..."
if [ -d ~/.dotfiles ]
then
  mv ~/.dotfiles ~/.dotfiles_${stamp}.bak
fi

echo "Cloning .dotfiles ..."
hash git >/dev/null && /usr/bin/env git clone https://github.com/m3talsmith/dotfiles.git ~/.dotfiles || {
  echo "git not installed"
  exit
}

echo "Backing up current files ..."
baseDir=${HOME}/.dotfiles
backupDir=${baseDir}/backups
currentBackupDir=${backupDir}/${stampDir}
mkdir -p ${currentBackupDir}
backupFiles=( .pryrc .screenrc .vimrc .vim .oh-my-zsh .zshrc .gitconfig )
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
