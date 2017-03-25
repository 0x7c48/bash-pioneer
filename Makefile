# All commands is install packages, think like 'install' is a prefix.

# Usage:
#	make all
#	make zshoh
# 	make install arg1 arg2 argn
# 	make test

# make manual:
# 	http://www.gnu.org/software/make/manual/make.html


ARGS = $(filter-out $@, $(MAKECMDGOALS))

# %: - rule which match any task name;
# @: - empty recipe = do nothing

help:
	less README.md

zshoh: zshrc/install_zsh_oh_my_zsh.sh
	zsh zshrc/install_zsh_oh_my_zsh.sh
update-zshrc:
	zsh zshrc/update_zshrc.sh
zsh-version:
	zsh --version

install: ubuntu/packages.sh
	zsh ubuntu/packages.sh $(ARGS)

all: ubuntu/packages.sh
	make zshoh
	zsh ubuntu/packages.sh all

test: ubuntu/packages.sh
	make install

# Call rule without 'install' prefix
# TODO: call role install only when not that role!
# make update-zshrc != No functon update-zshrc
%: install
	@:
