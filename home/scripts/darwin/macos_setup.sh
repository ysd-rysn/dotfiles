#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install awscli, gh
brew install awscli
brew install gh

# Configure aws cli
aws configure --profile chezmoi
export AWS_PROFILE=chezmoi

$HOME/dotfiles/home/scripts/macos_install.sh
$HOME/dotfiles/home/scripts/macos_defaults.sh
