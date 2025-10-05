# Dotfiles Scripts

This directory contains automation scripts for dotfiles management.

## Directory Structure

```
.scripts/
├── lib/              # Shared utility libraries
│   └── util.sh       # Common functions (logging, checks, etc.)
├── common/           # Cross-platform scripts
│   └── install_npm_global_packages.sh  # NPM global packages installer
└── darwin/           # macOS-specific scripts
    ├── macos_presetup.sh       # Initial setup (Homebrew, CLI tools)
    ├── macos_brew_bundle.sh    # Brewfile installation
    └── macos_defaults.sh       # System preferences
```

## Utility Library (`lib/util.sh`)

All scripts source the common library for consistent functionality:

### Logging Functions

- `log()` - Standard log with timestamp
- `log_info()` - Info message (blue)
- `log_success()` - Success message (green)
- `log_warning()` - Warning message (yellow)
- `log_error()` - Error message (red)

### Check Functions

- `check_command <cmd>` - Verify command exists
- `check_commands <cmd1> <cmd2> ...` - Check multiple commands
- `check_macos()` - Verify running on macOS
- `check_file <path>` - Verify file exists
- `check_dir <path>` - Verify directory exists
- `check_bw_session()` - Verify Bitwarden session is valid

### Utility Functions

- `create_dir_safe <dir> [perms]` - Create directory with permissions (default: 755)
- `write_file_safe <file> <content> [perms]` - Write file with permissions (default: 644)
- `brew_install_if_missing <package>` - Install Homebrew package if not present
- `git_add_remote_safe <name> <url>` - Add git remote idempotently
- `setup_error_trap()` - Setup ERR trap for error handling
- `script_header <title>` - Display formatted script header
- `script_footer <title>` - Display formatted script footer

## Usage Examples

### Source the utility library

```bash
#!/bin/bash
set -euo pipefail

source "$HOME/.scripts/lib/util.sh"
setup_error_trap

# Your script logic here
log_info "Starting process..."
check_macos || exit 1
log_success "Process complete!"
```

### Using utility functions

```bash
# Check multiple commands
check_commands git gh bw || exit 1

# Install packages
brew_install_if_missing bitwarden-cli
brew_install_if_missing gh

# Create directories securely
create_dir_safe "$HOME/.ssh" 700

# Write files securely
write_file_safe "$HOME/.ssh/config" "$CONFIG_CONTENT" 600

# Add git remote safely
git_add_remote_safe origin-ssh "git@github.com:user/repo"
```

## Configuration

All hardcoded values are externalized to `.chezmoi.toml.tmpl`:

```toml
[data.github]
    username = "ysd-rysn"
    repository = "dotfiles"
    ssh_key_name = "id-ed25519-github"

[data.bitwarden]
    github_ssh_item = "GitHub SSH Key"
    github_ssh_field = "private_key"

[data.paths]
    dotfiles_repo = "{{ .chezmoi.homeDir }}/dotfiles"
    scripts_dir = "{{ .chezmoi.homeDir }}/.scripts"
    scripts_darwin = "{{ .chezmoi.homeDir }}/dotfiles/home/.scripts/darwin"
    ssh_dir = "{{ .chezmoi.homeDir }}/.ssh"
```

Access in templates:

```bash
SSH_DIR="{{ .paths.ssh_dir }}"
GITHUB_USER="{{ .github.username }}"
```

## macOS Scripts

### `macos_presetup.sh`

Initial system setup:
- Install Homebrew
- Install CLI tools (bitwarden-cli, gh)
- Authenticate with Bitwarden
- Export BW_SESSION for subsequent scripts

### `macos_brew_bundle.sh`

Package installation:
- Install Rosetta 2 (Apple Silicon)
- Run `brew bundle` from Brewfile

### `macos_defaults.sh`

Apply system preferences:
- UI/UX settings
- Dock configuration
- Trackpad settings
- Mission Control
- Hot corners

## Common Scripts

### `install_npm_global_packages.sh`

Cross-platform NPM global package installer:
- Reads packages from `~/.config/npm/global-packages.json`
- Checks Node.js and jq availability
- Installs or updates packages globally
- Provides installation summary with success/failure counts
- Falls back to hardcoded list if jq is unavailable

Triggered automatically by chezmoi when `global-packages.json` changes.

Manual execution:
```bash
~/.scripts/common/install_npm_global_packages.sh
```

## Error Handling

All scripts use strict error handling:

```bash
set -euo pipefail                # Exit on error, undefined vars, pipe failures
trap 'log_error "..."' ERR       # Report error line numbers
```

## Development

When creating new scripts:

1. Source the common library
2. Use `set -euo pipefail`
3. Setup error trap
4. Use logging functions
5. Check dependencies upfront
6. Use utility functions for common operations
7. Display script header/footer for clarity

Example template:

```bash
#!/bin/bash
set -euo pipefail

source "$HOME/.scripts/lib/util.sh"
setup_error_trap
check_macos || exit 1

script_header "My Script Name"

# Check dependencies
check_commands git brew || exit 1

# Your logic here
log_info "Doing something..."
log_success "Done!"

script_footer "My Script Name"
```
