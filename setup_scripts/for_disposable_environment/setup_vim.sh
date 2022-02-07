#!/bin/bash

cd ~/

curl -OL https://raw.githubusercontent.com/ysd-rysn/dotfiles/main/.vimrc

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install plugins
vim -c PlugInstall -c q -c q
