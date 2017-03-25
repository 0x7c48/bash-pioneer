#!/bin/zsh

# ========================
# Bash tools for installing packages for Ubuntu 14.04

# Req:
#	bash: zsh	
#	OS - Ubuntu

# ZSH docs:
	# http://zsh.sourceforge.net/Doc/Release/Functions.html
	# http://www.opennet.ru/docs/RUS/bash_scripting_guide


SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
PWD=$(pwd)
LOGFILE=$SCRIPT_PATH/log/packages.log


function logo {
	echo
	echo '__________               .__             .__                                   '
	echo '\______   \_____    _____|  |__   ______ |__| ____   ____   ____   ___________ '
	echo ' |    |  _/\__  \  /  ___/  |  \  \____ \|  |/  _ \ /    \_/ __ \_/ __ \_  __ \'
	echo ' |    |   \ / __ \_\___ \|   Y  \ |  |_> >  (  <_> )   |  \  ___/\  ___/|  | \/'
	echo ' |______  /(____  /____  >___|  / |   __/|__|\____/|___|  /\___  >\___  >__|   '
	echo '        \/      \/     \/     \/  |__|                  \/     \/     \/       '
	echo
	echo
}


# ========== Helpers functions ==========

function setup {
	printf '%s\n' 'Setup Ubuntu 14.04 and tools for installing packages'
	CMD="echo $PASSWORD | sudo -S apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y aptitude"
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"  # Hide password
	if [ $LOGFILE ]
	then
		script -a -c "$CMD" $LOGFILE
	else
		script -c "$CMD" $LOGFILE
	fi
	printf '%s\n' 'Done'
}

function update {
	# Update packages
	CMD="echo $PASSWORD | sudo -S aptitude update -y"
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"
	script -a -c "$CMD" $LOGFILE
	printf '%s\n' 'Done'
}

function upgrade {
	# Upgrade packages
	CMD="echo $PASSWORD | sudo -S aptitude upgrade -y"
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"
	script -a -c "$CMD" $LOGFILE
	printf '%s\n' 'Done'
}

function add-apt-repository  {
	# Add repository
	CMD="echo $PASSWORD | sudo -S add-apt-repository "$1" -y"
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"
	script -a -c "$CMD" $LOGFILE
	printf '%s\n' 'Done'
}

function add-apt-repository {
	# Remove repository
	CMD="echo $PASSWORD | sudo -S add-apt-repository --remove "$1""
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"
	script -a -c "$CMD" $LOGFILE
	printf '%s\n' 'Done'	
}

function install {
	# Base install command
	# Copy everything to the file packages.log
	# Avoid prompt password for sudo: echo $PASSWORD | sudo -S reboot
	CMD="echo $PASSWORD | sudo -S aptitude install -y "$*""
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"  # Hide password
	script -a -c "$CMD" $LOGFILE
	printf '%s\n' 'Done'
}

function pip-install {
	# Avoid prompt password for sudo
	CMD="echo $PASSWORD | sudo -S pip install -U "$*""
	printf '%s\n' "${CMD:$((5 + ${#PASSWORD} + 11))}"
	script -a -c "$CMD" $LOGFILE
	printf '%s\n' 'Done'
}

function main {
	setup
	printf '%s\n' 'Installing packages for Ubuntu 14.04'	
}


# ========== Install function ==========

function ssh-key {
	cp ~/.ssh/id_rsa id_rsa.backup
	cp ~/.ssh/id_rsa.pub id_rsa.pub.backup
	cp ~/.ssh/known_hosts known_hosts.backup

	ssh-keygen -t rsa -C "EMAIL"
	ssh-add ~/.ssh/id_rsa
	# password for ssh
}

function developer {
	# Base packages for developers
	install git
	install python-dev python-setuptools python-pip binutils build-essential
	install libssl-dev libffi-dev libevent-dev libxml2-dev libxslt1-dev
	install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev 
	install libwebp-dev tcl8.6-dev tk8.6-dev python-tk

	pip-install pip
	pip-install virtualenv

	update
	upgrade

}

function gitconfig {
	git config --global user.name "NAME"
	# Show list
	git config user.name
	git config --list
	# git config --global core.editor emacs
	# git config --global merge.tool vimdiff
}


function bumblebee {
	# Bumblebee  http://mylinuxexplore.blogspot.com/2014/03/solved-nvidia-cant-access-secondary-gpu.html
	add-apt-repository ppa:bumblebee/stable
	update
	upgrade
	install bumblebee bumblebee-nvidia primus linux-headers-generic
	install nvidia-331-updates
	update
	upgrade

	# Bumblebee indicator
	install python-appindicator
	cd ~
	git clone https://github.com/Bumblebee-Project/bumblebee-ui.git
	cd bumblebee-ui
	echo $PASSWORD | sudo -S ./INSTALL
	echo $PASSWORD | sudo -S reboot
}

function check-bumblebee-indicator {
	# Check
	# alt + f2: bumblebee indicator
	optirun firefox
	optirun nvidia-settings -c :8	
}

function java8 {
	# Java
	add-apt-repository ppa:webupd8team/java
	update
	upgrade

	echo $PASSWORD | sudo -S echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | echo $PASSWORD | sudo -S  /usr/bin/debconf-set-selections
	install oracle-java8-installer
	update
	upgrade
}

function sublime-text2 {
	# Sublime Text 2   http://monkeyhacks.com/how-to-install-sublime-text-2-on-ubuntu-14-04
	cd ~
	wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
	tar xf "Sublime Text 2.0.2 x64.tar.bz2"
	echo $PASSWORD | sudo -S mv "Sublime Text 2" /opt/
	cd /opt/
	echo $PASSWORD | sudo -S ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime2
}

function sublime-text3 {
	# Sublime Text 3
	add-apt-repository -y ppa:webupd8team/sublime-text-3
	update
	upgrade
	
	install -y sublime-text-installer
	update 
	upgrade
}

function pycharm {
	# Releases
	# https://confluence.jetbrains.com/display/PYH/Previous+PyCharm+Releases
	# http://www.jetbrains.com/pycharm/download/
	cd /opt/
	echo $PASSWORD | sudo -S wget http://download-cf.jetbrains.com/python/pycharm-professional-4.0.1.tar.gz
	echo $PASSWORD | sudo -S tar -xzvf pycharm-*.tar.gz
	echo $PASSWORD | sudo -S ln -s /opt/pycharm-4.0.1/bin/pycharm.sh /usr/bin/pycharm
	/usr/bin/pycharm
	cd ~
	update 
	upgrade
}

function nginx {
	# nginx
	install -y nginx
}


function mscorefonts {
	#9 ttf-mscorefonts-installer
	sudo echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
	install ttf-mscorefonts-installer
	update
	upgrade
}

function postgresql {
	# Postgresql 9.4 Ubuntu 14.04
	#  http://www.postgresql.org/download/linux/ubuntu/
	sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
	  echo $PASSWORD | sudo -S apt-key add -
	update 

	# postgresql, pgadmin3
	install postgresql postgresql-contrib pgadmin3
	install python-psycopg2
	install libpq-dev
	update
	upgrade
}

function ngrok {
	# https://ngrok.com/
	# https://github.com/inconshreveable/ngrok
	cd
	mkdir bin
	cd bin
	wget https://dl.ngrok.com/ngrok_2.0.19_linux_amd64.zip
	unzip -o ngrok*.zip
}

function tools {
	# Utils
	install mc htop lshw-gtk gdebi-core p7zip-full unrar rar guake curl
	install unetbootin filezilla fabric colordiff
	update
	upgrade
}

function python-dev {
	pip-install django requests cryptography six
	pip-install --upgrade ipython[all]	
}

function google-chrome {
	# google-chrome
	# https://www.google.com/intl/en-US/chrome/browser/desktop/index.html
	cd ~
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	echo $PASSWORD | sudo -S dpkg -i google-chrome-stable_current_amd64.deb
	update
	upgrade

	/usr/bin/google-chrome
	echo $PASSWORD | sudo -S rm google-chrome*.deb
}

function chromium-browser {
	# chromium-browser
	install chromium-browser
}

function nautilus-dropbox {
	# nautilus-dropbox
	install nautilus-dropbox
}

function media {
	# amarok
	install cheese calibre vlc gimp amarok audacity
	update
	upgrade
}

function skype {
	# skype

	# skype fix
	install gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386 sni-qt:i386
	update
	upgrade
}

function variety {
	# Variety - Wallpaper Changer
	add-apt-repository -y ppa:peterlevi/ppa
	update
	upgrade

	install variety
}

function ubuntu {
	install ubuntu-restricted-extras libavcodec-extra
}

function unity-tweak-tool {
	install unity-tweak-tool compizconfig-settings-manager
}

function mysql {
	# MySql
	install python-mysqldb libmysqlclient-dev mysql-server mysql-client
	update
	upgrade
}

function db-tools {
	# DB tools
	pip-install pgcli
	cp --backup $PWD/pgclirc/.pgclirc $HOME/.pgclirc
}

function nodejs {
	# nodejs
	install nodejs
	install npm
}

function nodejs {
	# PIL
	install libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev
	echo $PASSWORD | sudo -S apt-get build-dep python-imaging
	install libjpeg62 libjpeg62-dev

	echo $PASSWORD | sudo -S ln -s /usr/include/freetype2 /usr/local/include/freetype
	echo $PASSWORD | sudo -S ln -s /lib/x86_64-linux-gnu/libz.so.1 /lib/
	echo $PASSWORD | sudo -S ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so.6 /usr/lib/
	echo $PASSWORD | sudo -S ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.62 /usr/lib/
}


# ========== Install all function ==========

function all {
	# Call all function with order.
	developer
	check-bumblebee-indicator
	db-tools
}


# ========== Test functions ==========

function test1 { 
	local i 
	print -- "f3, len(ags) = $#"
	for i in $*
	do
		print -- "$i"
	done
}


# ========== Script ==========
# Args case, TODO: make it for many args
if [ $1 ]
then
	logo
	# Custom prompt password
	echo
	stty -echo
	printf 'Enter [sudo] password: '
	IFS= read -r PASSWORD
	printf '\n'
	# setup
	# main

	# Run all input functon
    local i 
    for i in $* 
    do
	    if [ "$(type -f $i)" != "$i not found" ]
	    then
	    	# call function
	    	$i
	    else
	    	printf '%s %s\n' 'No functon' $i
	    fi
	done
else
    logo
    printf '%s\n' 'No args'
    echo
    printf '%s\n\n' 'List of all available args:'
    # Print all of functions, without helpers and test functions
    print -l ${(ok)functions}| grep -vE 'test|setup|setup|update|upgrade|add-apt-repository|add-apt-repository|install|pip-install' | column -c 100
    echo
fi
