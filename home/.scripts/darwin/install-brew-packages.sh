#!/bin/bash

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/../lib/util.sh"

# Setup error trap
setup_error_trap

# Check macOS and Homebrew
check_macos || exit 1
check_command brew || exit 1

script_header "Homebrew Bundle Installation"

BREWFILE="$HOME/.Brewfile"

# Check if Brewfile exists
check_file "$BREWFILE" || exit 1

log_info "Found Brewfile at $BREWFILE"

# Install Rosetta 2 on Apple Silicon
if [ "$(uname -m)" = "arm64" ]; then
	log_info "Installing Rosetta 2 for Apple Silicon compatibility..."
	if softwareupdate --install-rosetta --agree-to-license 2>/dev/null; then
		log_success "Rosetta 2 installed successfully"
	else
		log_info "Rosetta 2 already installed or not needed"
	fi
fi

# Install packages from Brewfile
log_info "Installing packages from Brewfile..."
if brew bundle --file="$BREWFILE"; then
	log_success "Brewfile installation completed successfully"
else
	log_error "Brewfile installation failed"
	exit 1
fi

script_footer "Homebrew Bundle Installation"
