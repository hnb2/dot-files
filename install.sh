#!/bin/bash
# This script will install all the tools I use at work or home, it
# will most likely overwrite everything you love and care about.
# Better launch this on a fresh install...

CUR_PATH=$(pwd)

#The default repository for downloaded softwares
MY_ENV=~/Dev
if [ -z "$1" ]
then
    echo "No path given, will use the default one: $MY_ENV"
else
    MY_ENV=$1
fi

if [ ! -d "$MY_ENV" ]
then
    mkdir -p "$MY_ENV"
fi

###########################
#Install the default tools#
###########################
sudo apt-get install -y ack-grep meld zsh tmux curl htop

###########################
#Install GIT from sources #
###########################
sudo apt-get remove -y git git-core
sudo apt-get install -y build-essential libssl-dev \
    libcurl4-gnutls-dev libexpat1-dev gettext unzip

cd "$MY_ENV"
echo "Downloading GIT..."
curl -LSso git.zip https://github.com/git/git/archive/v2.2.1.zip
unzip git.zip
rm git.zip
cd git-*
make prefix=/usr/local all
sudo make prefix=/usr/local install

#Use my git config
rm  ~/.gitconfig
ln -s "$CUR_PATH/.gitconfig" "$HOME"

###########################
# Configure ZSH           #
###########################
chsh -s /bin/zsh

#Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh

#Disable the auto naming of the windows (tmux conflict)
sed -i 's/#DISABLE_AUTO_TITLE="true"/DISABLE_AUTO_TITLE="true"/g' "$HOME/.zshrc"

#Alias to shorten the call to ack-grep
echo 'alias ack="ack-grep"' >> "$HOME/.zshrc"

###########################
#Install VIM from sources #
###########################
sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    ruby-dev mercurial

sudo apt-get remove -y vim vim-runtime gvim vim-tiny \
    vim-common vim-gui-common

cd "$MY_ENV"
echo "Downloading VIM..."
hg clone https://code.google.com/p/vim/
cd vim
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-cscope --prefix=/usr
make VIMRUNTIMEDIR=/usr/share/vim/vim74
sudo make install

sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim

#Use my vimrc file
ln -s "$CUR_PATH/.vimrc" "$HOME"

#Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

#Install syntastic
cd ~/.vim/bundle && \
git clone https://github.com/scrooloose/syntastic.git
