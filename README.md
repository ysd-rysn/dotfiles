# dotfiles

dotfiles managed with [chezmoi](https://www.chezmoi.io/)

# Usage

## Initial Setup

### Quick Install (Recommended)

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/ysd-rysn/dotfiles/main/init.sh)"
```

This will:
- Install chezmoi if not already installed
- Clone this repository
- Apply all dotfiles to your home directory

### Manual Install

```sh
# Install chezmoi
brew install chezmoi

# Initialize and apply dotfiles
chezmoi init --apply https://github.com/ysd-rysn/dotfiles.git
```

## Updating Dotfiles

### Apply Changes from Repository

```sh
chezmoi update
```

### Edit Dotfiles

```sh
# Edit a file (opens in $EDITOR)
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply
```

### Add New Files

```sh
# Add a file to chezmoi
chezmoi add ~/.newconfig

# Re-add to update existing managed file
chezmoi re-add ~/.zshrc
```

## Common Commands

```sh
# Check what would change
chezmoi diff

# See what files are managed
chezmoi managed

# Pull latest changes without applying
chezmoi git pull

# Push local changes to repository
chezmoi cd
git add .
git commit -m "Update configs"
git push
exit
```
