#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

BREWFILE="$HOME/Brwefile"
if [ -f "$BREWFILE" ]; then
	brew bundle --file="$BREWFILE"
else
	echo "Not found $BREWFILE"
fi
