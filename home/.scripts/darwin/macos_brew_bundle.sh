#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

BREWFILE="$HOME/.Brewfile"
if [ -f "$BREWFILE" ]; then
	echo "Install rosetta ..."
	softwareupdate --install-rosetta --agree-to-license
	echo "Install software in Brewfile  ..."
	brew bundle --file="$BREWFILE"
else
	echo "Not found $BREWFILE"
fi
