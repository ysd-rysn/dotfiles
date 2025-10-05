#!/bin/bash

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/../lib/util.sh"

# Setup error trap
setup_error_trap

# Check macOS
check_macos || exit 1

script_header "macOS Pre-Setup"

# Install Homebrew if not present
if ! command -v brew >/dev/null 2>&1; then
	log_info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add Homebrew to PATH
	if [ -f "/opt/homebrew/bin/brew" ]; then
		if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null; then
			(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
			log_info "Added Homebrew to .zprofile"
		fi
		eval "$(/opt/homebrew/bin/brew shellenv)"
		log_success "Homebrew installed successfully"
	else
		log_error "Homebrew installation failed"
		exit 1
	fi
else
	log_info "Homebrew already installed"
fi

# Install required CLI tools
log_info "Installing required CLI tools..."
brew_install_if_missing bitwarden-cli
brew_install_if_missing gh

# Reload Homebrew environment to ensure bw is in PATH
eval "$(brew shellenv)"

# Bitwarden authentication
log_info "Setting up Bitwarden authentication..."

# Ensure Bitwarden is logged in and unlocked
# These functions handle all state checking and user prompts
bw_ensure_logged_in || exit 1
bw_ensure_unlocked || exit 1

# Persist session to .zprofile for subsequent scripts
persist_bw_session

script_footer "macOS Pre-Setup"
log_info "BW_SESSION is available for subsequent scripts"
