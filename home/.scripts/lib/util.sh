#!/bin/bash

# Common utility functions for chezmoi scripts
# Source this file in your scripts with: source "$HOME/.scripts/lib/util.sh"

# Color codes for terminal output
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_GRAY='\033[0;90m'

# Logging functions with timestamp and color
log() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${COLOR_GRAY}[${timestamp}]${COLOR_RESET} $*"
}

log_info() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${COLOR_GRAY}[${timestamp}]${COLOR_RESET} ${COLOR_BLUE}INFO:${COLOR_RESET} $*"
}

log_success() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${COLOR_GRAY}[${timestamp}]${COLOR_RESET} ${COLOR_GREEN}SUCCESS:${COLOR_RESET} $*"
}

log_warning() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${COLOR_GRAY}[${timestamp}]${COLOR_RESET} ${COLOR_YELLOW}WARNING:${COLOR_RESET} $*" >&2
}

log_error() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${COLOR_GRAY}[${timestamp}]${COLOR_RESET} ${COLOR_RED}ERROR:${COLOR_RESET} $*" >&2
}

# Alias for backward compatibility
error() {
    log_error "$@"
}

# Check if a command exists
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        log_error "$cmd is not installed"
        return 1
    fi
    return 0
}

# Check multiple commands at once
check_commands() {
    local missing_commands=()
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_commands+=("$cmd")
        fi
    done

    if [ ${#missing_commands[@]} -gt 0 ]; then
        log_error "Missing required commands: ${missing_commands[*]}"
        return 1
    fi
    return 0
}

# Check if running on macOS
check_macos() {
    if [ "$(uname)" != "Darwin" ]; then
        log_error "This script is for macOS only"
        return 1
    fi
    return 0
}

# Check if a file exists
check_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi
    return 0
}

# Check if a directory exists
check_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        log_error "Directory not found: $dir"
        return 1
    fi
    return 0
}

# Create directory with proper permissions
create_dir_safe() {
    local dir="$1"
    local perms="${2:-755}"

    if [ ! -d "$dir" ]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir"
        chmod "$perms" "$dir"
        log_success "Directory created with permissions $perms"
    else
        log_info "Directory already exists: $dir"
    fi
}

# Write file with proper permissions
write_file_safe() {
    local file="$1"
    local content="$2"
    local perms="${3:-644}"

    log_info "Writing file: $file"
    echo "$content" > "$file"
    chmod "$perms" "$file"
    log_success "File written with permissions $perms"
}

# Check if Bitwarden session is valid
check_bw_session() {
    if [ -z "${BW_SESSION:-}" ]; then
        log_error "Bitwarden session not found"
        log_info "Run: export BW_SESSION=\$(bw unlock --raw)"
        return 1
    fi

    if ! bw unlock --check &> /dev/null; then
        log_error "Bitwarden session is invalid or expired"
        log_info "Run: export BW_SESSION=\$(bw unlock --raw)"
        return 1
    fi

    return 0
}

# Ensure Bitwarden CLI is logged in (idempotent)
bw_ensure_logged_in() {
    if ! command -v bw &>/dev/null; then
        log_error "Bitwarden CLI (bw) not found in PATH"
        return 1
    fi

    # Check login status (capture exit code safely)
    bw login --check 2>/dev/null
    local login_status=$?

    if [ $login_status -eq 0 ]; then
        log_info "Already logged into Bitwarden"
        return 0
    else
        log_info "Not logged in. Logging into Bitwarden..."
        # bw login --raw will prompt for email and password interactively
        local session
        session=$(bw login --raw)
        if [ $? -eq 0 ] && [ -n "$session" ]; then
            export BW_SESSION="$session"
            log_success "Bitwarden login successful"
            return 0
        else
            log_error "Bitwarden login failed"
            return 1
        fi
    fi
}

# Ensure Bitwarden vault is unlocked (idempotent)
bw_ensure_unlocked() {
    if ! command -v bw &>/dev/null; then
        log_error "Bitwarden CLI (bw) not found in PATH"
        return 1
    fi

    # If we have a session, check if it's still valid
    if [ -n "${BW_SESSION:-}" ]; then
        bw unlock --check 2>/dev/null
        local unlock_status=$?

        if [ $unlock_status -eq 0 ]; then
            log_info "Bitwarden vault already unlocked"
            return 0
        fi
    fi

    # Need to unlock (will prompt for master password)
    log_info "Unlocking Bitwarden vault..."
    local session
    session=$(bw unlock --raw)
    if [ $? -eq 0 ] && [ -n "$session" ]; then
        export BW_SESSION="$session"
        log_success "Bitwarden vault unlocked"
        return 0
    else
        log_error "Failed to unlock Bitwarden vault"
        return 1
    fi
}

# Get current Bitwarden session (ensures login + unlock)
bw_get_session() {
    bw_ensure_logged_in || return 1
    bw_ensure_unlocked || return 1
    echo "$BW_SESSION"
}

# Persist BW_SESSION to .zprofile (idempotent)
persist_bw_session() {
    local profile_file="${1:-$HOME/.zprofile}"

    if [ -z "${BW_SESSION:-}" ]; then
        log_warning "No BW_SESSION to persist"
        return 1
    fi

    log_info "Persisting BW_SESSION to $profile_file..."

    # Remove existing BW_SESSION lines
    if [ -f "$profile_file" ]; then
        grep -v "^export BW_SESSION=" "$profile_file" > "$profile_file.tmp" || true
        mv "$profile_file.tmp" "$profile_file"
    fi

    # Add new BW_SESSION
    echo "export BW_SESSION=\"$BW_SESSION\"" >> "$profile_file"
    log_success "BW_SESSION persisted to $profile_file"
    return 0
}

# Install Homebrew package if not already installed
brew_install_if_missing() {
    local package="$1"

    if brew list "$package" &>/dev/null; then
        log_info "$package already installed"
        return 0
    else
        log_info "Installing $package..."
        if brew install "$package"; then
            log_success "$package installed successfully"
            return 0
        else
            log_error "Failed to install $package"
            return 1
        fi
    fi
}

# Add git remote if it doesn't exist (idempotent)
git_add_remote_safe() {
    local name="$1"
    local url="$2"

    if git remote get-url "$name" &>/dev/null; then
        log_info "Git remote '$name' already exists"
        return 0
    else
        log_info "Adding git remote '$name'..."
        if git remote add "$name" "$url"; then
            log_success "Git remote '$name' added successfully"
            return 0
        else
            log_error "Failed to add git remote '$name'"
            return 1
        fi
    fi
}

# Setup error trap with line number reporting
setup_error_trap() {
    trap 'log_error "Script failed on line $LINENO"' ERR
}

# Display script header
script_header() {
    local title="$1"
    echo ""
    log_info "=================================="
    log_info "$title"
    log_info "=================================="
    echo ""
}

# Display script footer
script_footer() {
    local title="$1"
    echo ""
    log_success "=================================="
    log_success "$title - Complete!"
    log_success "=================================="
    echo ""
}
