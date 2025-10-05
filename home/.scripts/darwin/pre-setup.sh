#!/bin/bash

set -euo pipefail

# Source common utilities
source "../lib/util.sh"

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

# Bitwarden authentication
log_info "Setting up Bitwarden authentication..."

# Check if already logged in
if bw login --check &>/dev/null; then
	log_info "Already logged into Bitwarden"

	# Check if already unlocked
	if [ -n "${BW_SESSION:-}" ] && bw unlock --check &>/dev/null; then
		log_info "Bitwarden already unlocked"
	else
		log_info "Unlocking Bitwarden vault..."
		export BW_SESSION=$(bw unlock --raw)
		log_success "Bitwarden vault unlocked"
	fi
else
	log_info "Logging into Bitwarden..."
	export BW_SESSION=$(bw login --raw)
	log_success "Bitwarden login successful"
fi

# Persist BW_SESSION to shell profile for subsequent scripts
# Remove any existing BW_SESSION lines to ensure idempotency
if [ -f "$HOME/.zprofile" ]; then
	grep -v "^export BW_SESSION=" "$HOME/.zprofile" > "$HOME/.zprofile.tmp" || true
	mv "$HOME/.zprofile.tmp" "$HOME/.zprofile"
fi

# Add new BW_SESSION
echo "export BW_SESSION=\"$BW_SESSION\"" >> "$HOME/.zprofile"
log_info "BW_SESSION persisted to .zprofile"

script_footer "macOS Pre-Setup"
log_info "BW_SESSION is available for subsequent scripts"
