#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

BREWFILE="$HOME/dotfiles/home/dot_Brewfile"
if [ -f "$BREWFILE" ]; then
	softwareupdate --install-rosetta --agree-to-license
	brew bundle --file="$BREWFILE"
else
	echo "Not found $BREWFILE"
fi
