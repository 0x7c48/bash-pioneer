# ========================
# Tools for update .zshrc file.
# Compare local .zshrc in home dir and repo .zshrc


# .zshrc
printf 'Compare files %s and %s \n\n' $HOME/.zshrc $PWD/zshrc/.zshrc
git diff $HOME/.zshrc $PWD/zshrc/.zshrc | colordiff | less -R
echo
echo

# plugins
printf 'Compare files %s and %s \n\n' $HOME/.oh-my-zsh/custom/ $PWD/oh-my-zsh/custom/
git diff $HOME/.oh-my-zsh/custom/ $PWD/oh-my-zsh/custom/ | colordiff | less -R

# .aliases
printf 'Compare files %s and %s\n\n' $HOME/.aliases $PWD/zshrc/.aliases
if [ $HOME/.aliases ]
then
	echo
else
	cat $HOME/.aliases
fi

# diff -y $HOME/.aliases $PWD/zshrc/.aliases | colordiff
git diff $HOME/.aliases $PWD/zshrc/.aliases | colordiff | less -R


echo
stty -echo
printf 'Update [~/.zshrc .oh-my-zsh/custom/ ~/.aliases]? [type and  press enter] y/n: '
IFS= read -r YESNO

if [ $YESNO = "y" ]
then
	rsync -b --suffix=.backup $PWD/zshrc/.zshrc $HOME/.zshrc
	cp -r $PWD/oh-my-zsh/custom/* $HOME/.oh-my-zsh/custom/
	rsync -b --suffix=.backup $PWD/zshrc/.aliases $HOME/.aliases
	printf 'Updated'
else
	printf 'Canceled'
fi
echo
