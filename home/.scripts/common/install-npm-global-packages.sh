#!/bin/bash

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/../lib/util.sh"

# Setup error trap
setup_error_trap

script_header "NPM Global Packages Installation"

# Configuration
PACKAGES_FILE="$HOME/.config/npm/global-packages.json"

# Check if packages file exists
if [ ! -f "$PACKAGES_FILE" ]; then
    log_warning "No global packages file found at $PACKAGES_FILE"
    exit 0
fi

log_info "Found packages file: $PACKAGES_FILE"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    log_warning "Node.js is not installed. Skipping npm global package installation."
    exit 0
fi

log_info "Node.js version: $(node --version)"
log_info "npm version: $(npm --version)"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    log_warning "jq is not installed. Installing packages without jq..."

    # Fallback: install hardcoded packages
    FALLBACK_PACKAGES=(
        "@anthropic-ai/claude-code"
        "@google/gemini-cli"
        "@openai/codex"
        "gluestack-ui"
    )

    for package in "${FALLBACK_PACKAGES[@]}"; do
        log_info "Installing $package..."
        if npm install -g "$package"; then
            log_success "$package installed successfully"
        else
            log_error "Failed to install $package"
        fi
    done

    script_footer "NPM Global Packages Installation"
    exit 0
fi

# Read packages from JSON file and install
log_info "Reading packages from $PACKAGES_FILE..."

PACKAGES=$(jq -r '.packages[]' "$PACKAGES_FILE")
PACKAGE_COUNT=$(echo "$PACKAGES" | wc -l | tr -d ' ')

log_info "Found $PACKAGE_COUNT packages to install"

INSTALLED=0
FAILED=0

while IFS= read -r package; do
    if [ -n "$package" ]; then
        log_info "Installing $package..."
        if npm install -g "$package" 2>&1 | grep -q "up to date"; then
            log_info "$package is already up to date"
            ((INSTALLED++))
        elif npm install -g "$package"; then
            log_success "$package installed successfully"
            ((INSTALLED++))
        else
            log_error "Failed to install $package"
            ((FAILED++))
        fi
    fi
done <<< "$PACKAGES"

# Summary
echo ""
log_success "Installation Summary:"
log_info "  ✓ Successfully installed/updated: $INSTALLED"
if [ $FAILED -gt 0 ]; then
    log_warning "  ✗ Failed: $FAILED"
fi

script_footer "NPM Global Packages Installation"

# Exit with error if any package failed
[ $FAILED -eq 0 ]
