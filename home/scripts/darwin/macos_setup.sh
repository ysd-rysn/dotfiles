#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install awscli, gh
brew install awscli
brew install gh

# Configure aws cli
aws configure --profile chezmoi

$SCRIPT_DIR/macos_install.sh
$SCRIPT_DIR/macos_defaults.sh
