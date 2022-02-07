#!/bin/bash

cd ~/

curl -OL https://raw.githubusercontent.com/ysd-rysn/dotfiles/main/.tmux.conf

# install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# to install plugins, press "prefix + I" in tmux
