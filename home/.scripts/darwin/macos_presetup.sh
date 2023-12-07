#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

if ! command -v brew >/dev/null; then
	# Install homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# Install bitwarden-cli, gh
brew install bitwarden-cli
brew install gh

# Login Bitwarden
export BW_SESSION=$(bw login --raw)

SCRIPT_DIR=$HOME/dotfiles/home/.chezmoiscripts/darwin
