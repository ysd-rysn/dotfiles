#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

if ! command -v brew >/dev/null; then
	# Install homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# Install awscli, gh
brew install awscli
brew install gh

# Configure aws cli
aws configure --profile chezmoi
export AWS_PROFILE=chezmoi

SCRIPT_DIR=$HOME/dotfiles/home/scripts/darwin
$SCRIPT_DIR/macos_install.sh
$SCRIPT_DIR/macos_defaults.sh
