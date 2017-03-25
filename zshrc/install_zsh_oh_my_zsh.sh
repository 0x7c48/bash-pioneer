# ========================
# Bash tools
# Install zsh and set custom .zshrc
# ========================
# Oh-My-Zsh
# http://ohmyz.sh
# https://github.com/robbyrussell/oh-my-zsh

# ========================
# Req:
#	OS - Ubuntu

printf '%s\n\n' 'Install zsh for Ubuntu'
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install zsh -y

git pull origin master

PWD=$(pwd)

printf '%s\n\n' 'Install Oh-My-Zsh for Ubuntu'
if ls $HOME/.oh-my-zsh* 1> /dev/null 2>&1; 
then
	sh $HOME/.oh-my-zsh/tools/upgrade.sh
else
	printf '%s\n\n' 'Clone https://github.com/robbyrussell/oh-my-zsh.git'
	git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

printf '%s\n\n' 'Install custom plugins Oh-My-Zsh'
cp -r $PWD/oh-my-zsh/custom/* $HOME/.oh-my-zsh/custom/

printf '%s\n\n' 'Copy .aliases'
printf '%s\n\n' 'Compare aliases files'
diff $PWD/zshrc/.aliases $HOME/.aliases
printf '%s\n' 'Replace .aliases'
cp --backup $PWD/zshrc/.aliases $HOME/.aliases

printf '%s\n\n' 'Install custom .zshrc'
printf '%s\n\n' 'Compare .zshrc files'
diff $PWD/zshrc/.zshrc $HOME/.zshrc
printf '%s\n' 'Replace .zshrc'
cp --backup $PWD/zshrc/.zshrc $HOME/.zshrc

source ~/.zshrc
exec zsh
