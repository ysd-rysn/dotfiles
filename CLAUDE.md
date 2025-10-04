# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **chezmoi-managed dotfiles repository** for macOS development environments. The repository uses chezmoi's templating and secret management features to handle multiple machines and sensitive data.

### Key Architecture Patterns

**Directory Structure**:
- `/home/` - The actual source directory containing all dotfiles (set via `.chezmoiroot`)
- Root-level files are chezmoi configuration only
- All managed dotfiles live under `home/` with chezmoi prefixes

**Naming Convention**:
- `dot_` prefix = files starting with `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_` prefix = 600 permissions
- `.tmpl` extension = files using Go template syntax
- Scripts in `.chezmoiscripts/` use `run_once_before_` and `run_once_after_` prefixes

**Template System**:
- Uses Bitwarden integration for secrets (`bitwardenFields`, `bitwarden` functions)
- OS-specific conditionals in `.chezmoiignore` (macOS-only files like Brewfile)
- External dependencies fetched via `.chezmoiexternal.toml` (oh-my-zsh, vim-plug, tmux TPM)

**Secret Management**:
- Git credentials sourced from Bitwarden (see `dot_gitconfig.tmpl`)
- AWS credentials configured for `ap-northeast-1` region
- Never commit actual secrets - always use template functions

## Common Development Commands

### Working with Dotfiles

```bash
# Preview changes before applying
chezmoi diff

# Edit a managed file (opens in $EDITOR)
chezmoi edit ~/.zshrc

# Apply changes after editing
chezmoi apply

# Add a new file to management
chezmoi add ~/.newconfig

# Update an existing managed file from home directory
chezmoi re-add ~/.zshrc
```

### Updating Brewfile

```bash
# Generate current Brewfile
brew bundle dump --force --file=~/.Brewfile

# Add to chezmoi
chezmoi re-add ~/.Brewfile
```

### Testing Changes

```bash
# Dry-run to see what would change
chezmoi apply --dry-run --verbose

# Execute templates to check syntax
chezmoi execute-template < home/dot_gitconfig.tmpl
```

### Syncing Changes

```bash
# Pull latest from repository
chezmoi git pull

# Enter source directory for git operations
chezmoi cd
git add .
git commit -m "Update configs"
git push
exit

# Or pull and apply in one command
chezmoi update
```

## Important Notes

**When modifying templates**:
- Test template syntax with `chezmoi execute-template < file.tmpl`
- Bitwarden CLI must be authenticated for secret templates to work
- macOS-specific files are automatically ignored on non-Darwin systems

**When adding new files**:
- Use `chezmoi add` from the home directory, not from the repository
- Files are automatically stored in `home/` with appropriate prefixes
- Check `.chezmoiignore` if adding macOS-specific configurations

**External dependencies**:
- Managed in `home/.chezmoiexternal.toml`
- Refreshed weekly (168h) automatically
- Includes: oh-my-zsh, zsh-syntax-highlighting, vim-plug, tmux TPM

**Ignored directories** (not synced):
- VSCode settings (vscode/)
- iTerm2 settings (iTerm2/)
- Raycast settings (raycast/)
- oh-my-zsh cache
