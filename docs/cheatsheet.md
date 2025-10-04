# chezmoi Cheat Sheet

Practical reference guide for [chezmoi](https://www.chezmoi.io/) - a dotfiles management tool

---

## 📦 Initial Setup

### Installation

```bash
# Homebrew (macOS/Linux)
brew install chezmoi

# Script-based (all platforms)
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Initialization

```bash
# Initialize a new repository
chezmoi init

# Initialize from GitHub repository
chezmoi init https://github.com/username/dotfiles.git

# Initialize and apply in one step
chezmoi init --apply https://github.com/username/dotfiles.git
```

---

## 🔧 Basic Commands

### File Management

```bash
# Add a file to chezmoi
chezmoi add ~/.zshrc

# Add multiple files at once
chezmoi add ~/.zshrc ~/.vimrc ~/.tmux.conf

# Add an entire directory
chezmoi add ~/.config/nvim

# Re-add an existing file (update)
chezmoi re-add ~/.zshrc
```

### Edit and Apply

```bash
# Edit a file (opens in $EDITOR)
chezmoi edit ~/.zshrc

# Edit with specific editor
EDITOR=vim chezmoi edit ~/.zshrc

# Check differences
chezmoi diff

# See what would change (dry-run)
chezmoi apply --dry-run --verbose

# Apply changes
chezmoi apply

# Apply specific file only
chezmoi apply ~/.zshrc
```

### Source File Inspection

```bash
# List managed files
chezmoi managed

# Navigate to source directory
chezmoi cd

# Show source directory path
chezmoi source-path

# Show source path of specific file
chezmoi source-path ~/.zshrc
```

---

## 🔄 Updates and Git Integration

### Repository Updates

```bash
# Pull latest from repository and apply
chezmoi update

# Pull only (don't apply)
chezmoi git pull

# Pull, check diff, then apply
chezmoi git pull && chezmoi diff && chezmoi apply
```

### Push Changes

```bash
# Navigate to source directory and perform git operations
chezmoi cd
git add .
git commit -m "Update dotfiles"
git push
exit

# Or in one line
chezmoi cd && git add . && git commit -m "Update" && git push && exit
```

### Git Shortcuts

```bash
# git pull
chezmoi git pull

# git status
chezmoi git status

# Run arbitrary git command
chezmoi git -- log --oneline
```

---

## 📝 File Attributes and Prefixes

### Naming Conventions

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dot_` | File starting with `.` | `dot_zshrc` → `~/.zshrc` |
| `private_` | 600 permissions (owner only) | `private_key` → `~/key` (600) |
| `executable_` | Add execute permission | `executable_script.sh` → `~/script.sh` (755) |
| `symlink_` | Symbolic link | `symlink_config.tmpl` |
| `readonly_` | Read-only | `readonly_data` |
| `exact_` | Exact directory management | `exact_dot_config` |

### Combined Examples

```bash
# ~/.ssh/config (600 permissions)
private_dot_ssh/private_config

# ~/.local/bin/script.sh (executable)
dot_local/bin/executable_script.sh

# ~/.gitconfig (read-only)
readonly_dot_gitconfig
```

---

## 🎨 Template Features

### Template Extension

```bash
# Treat as template
dot_gitconfig.tmpl
```

### Using Variables

```bash
# ~/.chezmoidata.toml or ~/.config/chezmoi/chezmoi.toml
[data]
    email = "user@example.com"
    name = "Your Name"
```

```bash
# dot_gitconfig.tmpl
[user]
    email = "{{ .email }}"
    name = "{{ .name }}"
```

### Built-in Variables

```go
{{ .chezmoi.os }}           // darwin, linux, windows
{{ .chezmoi.arch }}         // amd64, arm64
{{ .chezmoi.hostname }}     // hostname
{{ .chezmoi.username }}     // username
{{ .chezmoi.homeDir }}      // home directory
{{ .chezmoi.sourceDir }}    // chezmoi source directory
```

### Conditionals

```go
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific settings
export HOMEBREW_PREFIX="/opt/homebrew"
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific settings
export PATH="$HOME/.local/bin:$PATH"
{{- end }}
```

### Loops

```go
{{- range .packages }}
brew install {{ . }}
{{- end }}
```

---

## 🔐 Secret Management

### 1Password Integration

```bash
# .chezmoi.toml.tmpl
[onepassword]
    command = "op"

# Use in templates
{{ (onepasswordRead "op://vault/item/field").value }}
```

### Encrypted Files

```bash
# age (recommended)
chezmoi add --encrypt ~/.ssh/private_key

# gpg
chezmoi add --encrypt --gpg-recipient john@example.com ~/.ssh/private_key
```

### Configuration (.chezmoi.toml)

```toml
encryption = "age"
[age]
    identity = "~/.config/chezmoi/key.txt"
    recipient = "age1..."
```

---

## 🚀 Script Execution

### Script Types

| Prefix | Execution Timing |
|--------|-----------------|
| `run_` | Run every time |
| `run_once_` | Run only once |
| `run_before_` | Run before `chezmoi apply` |
| `run_after_` | Run after `chezmoi apply` |
| `run_onchange_` | Run only when content changes |

### Execution Order Control

```bash
# Specify execution order (01, 02, 03...)
run_once_before_01_install-homebrew.sh
run_once_before_02_install-packages.sh
run_after_99_cleanup.sh
```

### Script Example

```bash
# .chezmoiscripts/run_once_before_install-homebrew.sh
#!/bin/bash
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
```

---

## 🎯 Practical Examples

### Managing Brewfile

```bash
# Add Brewfile
chezmoi add ~/.Brewfile

# Or with specific filename
chezmoi add --template dot_Brewfile

# OS-specific management
{{- if eq .chezmoi.os "darwin" }}
# macOS packages
brew "mas"
{{- end }}
```

### Multi-Machine Configuration

```bash
# dot_zshrc.tmpl
{{- if eq .chezmoi.hostname "work-laptop" }}
export WORK_MODE=true
{{- else if eq .chezmoi.hostname "personal-mac" }}
export PERSONAL_MODE=true
{{- end }}
```

### External File Retrieval

```toml
# .chezmoiexternal.toml
[".oh-my-zsh"]
    type = "archive"
    url = "https://github.com/ohmyzsh/ohmyzsh/archive/master.tar.gz"
    stripComponents = 1
```

---

## 🔍 Troubleshooting

### Debug Mode

```bash
# Verbose logging
chezmoi apply --verbose

# See what would be executed
chezmoi apply --dry-run --verbose

# Check template output
chezmoi execute-template < ~/.local/share/chezmoi/dot_zshrc.tmpl
```

### Common Issues

#### 1. Files Not Updating

```bash
# Clear cache
rm -rf ~/.cache/chezmoi

# Force apply
chezmoi apply --force
```

#### 2. Template Errors

```bash
# Check template syntax
chezmoi execute-template < template_file.tmpl

# Verify data
chezmoi data
```

#### 3. Permission Errors

```bash
# Check current permissions
chezmoi managed --include=dirs,files --path-style=absolute

# Modify source file
chezmoi cd
# Rename file (e.g., add private_ prefix)
```

#### 4. Unwanted Files Being Managed

```bash
# Add to .chezmoiignore
echo "unwanted-file" >> ~/.local/share/chezmoi/.chezmoiignore
```

---

## 🛠️ Advanced Usage

### Custom Diff Tool

```bash
# .chezmoi.toml
[diff]
    pager = "delta"
    command = "code"
    args = ["--wait", "--diff"]
```

### Merge Tool Configuration

```bash
# .chezmoi.toml
[merge]
    command = "nvim"
    args = ["-d", "{{ "{{ .Destination }}" }}", "{{ "{{ .Source }}" }}", "{{ "{{ .Target }}" }}"]
```

### Custom Template Functions

```toml
# .chezmoi.toml
[template]
    [template.funcs]
        myFunction = "echo 'custom output'"
```

### Conditional File Management

```bash
# .chezmoiignore
{{- if ne .chezmoi.os "darwin" }}
.Brewfile
Library/
{{- end }}

{{- if ne .email "work@company.com" }}
.config/work/
{{- end }}
```

---

## 📚 Useful Commands

### Information

```bash
# Check chezmoi configuration
chezmoi doctor

# View data variables
chezmoi data

# Check status
chezmoi status

# List managed files (with paths)
chezmoi managed --include=files,dirs --path-style=absolute
```

### Cleanup

```bash
# Remove unmanaged files
chezmoi unmanaged

# Stop managing specific file
chezmoi forget ~/.oldconfig

# Clear cache
chezmoi purge
```

### Deploying to Other Machines

```bash
# 1. Initialize and apply on new machine
chezmoi init --apply https://github.com/username/dotfiles.git

# 2. Regular updates
chezmoi update

# 3. Check local changes
chezmoi diff
```

---

## 📖 Reference

### Official Documentation
- [Official Site](https://www.chezmoi.io/)
- [User Guide](https://www.chezmoi.io/user-guide/command-overview/)
- [GitHub](https://github.com/twpayne/chezmoi)

### Configuration Examples
- [Official Samples](https://github.com/twpayne/dotfiles)
- [Community Examples](https://dotfiles.github.io/)

### Help

```bash
# Command help
chezmoi help

# Specific command help
chezmoi help add
chezmoi help apply
```

---

## 💡 Best Practices

1. **Start Small**: Begin managing important files gradually
2. **Regular Commits**: Commit and push changes frequently
3. **Use Templates**: Handle environment differences with templates
4. **Security**: Always encrypt or externally manage secrets
5. **Documentation**: Document custom settings and dependencies in README
6. **Test**: Use `--dry-run` on new machines before applying
7. **Backup**: Backup important files before initial application

---

## 🔗 Usage Examples for This Dotfiles

```bash
# Update Brewfile
brew bundle dump --force --file=~/.Brewfile
chezmoi re-add ~/.Brewfile

# Edit configuration file
chezmoi edit ~/.zshrc

# Check changes and apply
chezmoi diff
chezmoi apply

# Push to GitHub
chezmoi cd
git add .
git commit -m "Update configs"
git push
exit
```
