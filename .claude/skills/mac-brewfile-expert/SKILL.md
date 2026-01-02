---
name: mac-brewfile-expert
description: Expert in Homebrew Brewfiles for managing macOS packages, casks, Mac App Store apps, and dependencies. Use when working with Brewfiles, Homebrew bundle, package management, or when the user asks about managing macOS applications, brew packages, or system setup automation.
allowed-tools: Read, Grep, Glob, Bash
---

# Mac Brewfile Expert

An expert skill for working with Homebrew Brewfiles to manage packages, casks, Mac App Store apps, and system dependencies on macOS.

## When to use this skill

Use this skill when:
- Creating or updating Brewfiles
- Managing Homebrew packages and casks
- Setting up new Macs with automation
- Organizing package dependencies
- Troubleshooting Brew bundle issues
- Migrating package lists between machines

## Core concepts

### What is a Brewfile?

A Brewfile is a declarative configuration file for Homebrew that lists all packages, casks, taps, and Mac App Store apps you want installed. It enables reproducible system setups.

### Basic Brewfile structure
```ruby
# Brewfile

# Taps (third-party repositories)
tap "homebrew/bundle"
tap "homebrew/cask-fonts"

# Formulae (command-line tools)
brew "git"
brew "vim"
brew "node"

# Casks (GUI applications)
cask "visual-studio-code"
cask "google-chrome"
cask "iterm2"

# Mac App Store apps (requires mas)
mas "Xcode", id: 497799835
mas "1Password", id: 1333542190

# VS Code extensions (requires vscode)
vscode "ms-python.python"
vscode "golang.go"
```

## Quick start

### Generate Brewfile from current system
```bash
# Dump all installed packages to Brewfile
brew bundle dump

# Dump to specific location
brew bundle dump --file=~/dotfiles/Brewfile

# Overwrite existing Brewfile
brew bundle dump --force
```

### Install from Brewfile
```bash
# Install everything in Brewfile
brew bundle

# From specific location
brew bundle --file=~/dotfiles/Brewfile

# Verbose output
brew bundle -v

# Dry run (show what would be installed)
brew bundle --dry-run
```

### Clean up
```bash
# Remove packages not in Brewfile
brew bundle cleanup

# Force removal without prompting
brew bundle cleanup --force

# See what would be removed
brew bundle cleanup --dry-run
```

## Brewfile syntax

### Taps
```ruby
# Add third-party repository
tap "homebrew/cask-versions"
tap "homebrew/cask-fonts"
tap "mongodb/brew"
tap "hashicorp/tap"

# With specific URL
tap "user/repo", "https://github.com/user/repo"
```

### Formulae (CLI tools)
```ruby
# Basic installation
brew "git"
brew "vim"
brew "python"

# With specific arguments
brew "imagemagick", args: ["with-webp"]

# Restart service after installation
brew "postgresql", restart_service: true

# Start service after installation
brew "redis", start_service: true

# Link in specific way
brew "python", link: true

# With specific options
brew "emacs", args: ["with-cocoa", "with-gnutls"]
```

### Casks (GUI apps)
```ruby
# Basic installation
cask "visual-studio-code"
cask "docker"
cask "slack"

# With specific arguments
cask "xquartz", args: { appdir: "/Applications" }

# Require password for installation
cask "dropbox", args: { require_sha: true }

# Install beta/preview versions
cask "firefox-developer-edition"
cask "visual-studio-code-insiders"
```

### Mac App Store
```ruby
# Requires 'mas' to be installed first
brew "mas"

# Install MAS apps by ID
mas "1Password", id: 1333542190
mas "Xcode", id: 497799835
mas "The Unarchiver", id: 425424353

# Find app ID
# Run: mas search "App Name"
# Or check App Store URL
```

### VS Code extensions
```ruby
# Requires vscode formula/cask
vscode "ms-python.python"
vscode "golang.go"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
```

### Whalebrew packages
```ruby
# Requires whalebrew
brew "whalebrew"
whalebrew "whalebrew/wget"
```

## Organization strategies

### Single Brewfile
```ruby
# ~/Brewfile
# Simple, all-in-one configuration

tap "homebrew/bundle"
tap "homebrew/cask"

# Development tools
brew "git"
brew "gh"
brew "node"
brew "python"

# Apps
cask "visual-studio-code"
cask "iterm2"
```

### Organized by category
```ruby
# ~/Brewfile

# ===== Taps =====
tap "homebrew/bundle"
tap "homebrew/cask-fonts"

# ===== Shell & Terminal =====
brew "zsh"
brew "tmux"
brew "starship"
cask "iterm2"
cask "warp"

# ===== Development =====
brew "git"
brew "gh"
brew "node"
brew "python"
brew "go"
brew "rust"
cask "visual-studio-code"
cask "docker"

# ===== Fonts =====
cask "font-fira-code"
cask "font-jetbrains-mono"

# ===== Productivity =====
cask "alfred"
cask "rectangle"
mas "Things 3", id: 904280696

# ===== Communication =====
cask "slack"
cask "discord"
cask "zoom"
```

### Split by machine type
```ruby
# ~/Brewfile.common (shared)
brew "git"
brew "vim"
brew "zsh"

# ~/Brewfile.work (work-specific)
!include Brewfile.common
brew "awscli"
cask "slack"
cask "zoom"

# ~/Brewfile.personal (personal-specific)
!include Brewfile.common
cask "spotify"
cask "steam"
```

### Split by purpose
```
dotfiles/
  Brewfile           # Core utilities
  Brewfile.dev       # Development tools
  Brewfile.apps      # GUI applications
  Brewfile.fonts     # Fonts
```

## Advanced patterns

### Conditional installation
Use shell scripts to generate Brewfile dynamically:

```bash
#!/bin/bash
# generate-brewfile.sh

cat > Brewfile <<EOF
tap "homebrew/bundle"

# Core tools
brew "git"
brew "vim"
EOF

if [[ $(hostname) == "work-laptop" ]]; then
    cat >> Brewfile <<EOF
# Work-specific
brew "awscli"
cask "slack"
EOF
fi

if [[ -d "$HOME/dev" ]]; then
    cat >> Brewfile <<EOF
# Development
brew "node"
brew "python"
brew "docker"
EOF
fi
```

### Version pinning
```ruby
# Pin specific version
brew "python@3.9"
brew "node@16"
brew "postgresql@14"

# Use specific tap for version
tap "homebrew/cask-versions"
cask "firefox-esr"
```

### Arguments and options
```ruby
# Build from source
brew "vim", args: ["build-from-source"]

# With specific features
brew "ffmpeg", args: [
  "with-fdk-aac",
  "with-freetype",
  "with-libvpx",
  "with-opus"
]

# Custom app directory
cask "steam", args: { appdir: "/Applications/Games" }

# Require checksum verification
cask "1password", args: { require_sha: true }
```

### Service management
```ruby
# Start service at login
brew "postgresql", restart_service: true
brew "redis", start_service: true
brew "nginx", restart_service: :changed

# Don't start automatically
brew "mysql"  # Manual start with: brew services start mysql
```

## Common workflows

### New machine setup
```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone https://github.com/username/dotfiles.git ~/dotfiles

# 3. Install everything
cd ~/dotfiles
brew bundle

# 4. Verify installation
brew bundle check
```

### Update Brewfile
```bash
# Manually edit Brewfile
vim Brewfile

# Install new packages
brew bundle

# Remove packages not in Brewfile
brew bundle cleanup
```

### Keep system in sync
```bash
# Update Homebrew
brew update

# Upgrade packages
brew upgrade

# Ensure system matches Brewfile
brew bundle check || brew bundle

# Clean up old versions
brew cleanup
```

### Export current setup
```bash
# Dump to new Brewfile
brew bundle dump --file=Brewfile.backup

# Compare with existing
diff Brewfile Brewfile.backup

# Update main Brewfile with new packages
# Manually merge or overwrite
```

## Package categories

### Essential CLI tools
```ruby
# Shell
brew "zsh"
brew "bash"
brew "fish"

# Core utilities
brew "coreutils"
brew "findutils"
brew "gnu-sed"
brew "grep"

# Modern replacements
brew "bat"        # Better cat
brew "exa"        # Better ls
brew "fd"         # Better find
brew "ripgrep"    # Better grep
brew "fzf"        # Fuzzy finder
brew "delta"      # Better diff

# System tools
brew "htop"
brew "btop"
brew "ncdu"
brew "tree"
```

### Development tools
```ruby
# Version control
brew "git"
brew "gh"
brew "git-lfs"

# Languages
brew "node"
brew "python"
brew "go"
brew "rust"
brew "ruby"

# Database
brew "postgresql"
brew "mysql"
brew "redis"
brew "mongodb-community"

# Containerization
brew "docker"
brew "docker-compose"
cask "docker"

# Infrastructure
brew "terraform"
brew "ansible"
brew "kubernetes-cli"
```

### Productivity apps
```ruby
# Terminal
cask "iterm2"
cask "warp"
cask "alacritty"

# Editors
cask "visual-studio-code"
cask "sublime-text"
cask "neovim"

# Window management
cask "rectangle"
cask "amethyst"
cask "raycast"

# Productivity
cask "alfred"
cask "notion"
mas "Things 3", id: 904280696
```

### Fonts
```ruby
tap "homebrew/cask-fonts"

cask "font-fira-code"
cask "font-jetbrains-mono"
cask "font-hack-nerd-font"
cask "font-source-code-pro"
cask "font-cascadia-code"
```

## Troubleshooting

### Check Brewfile validity
```bash
# Validate syntax
brew bundle check

# See what's missing
brew bundle check --verbose

# List what would be installed
brew bundle list --all
```

### Common errors

#### Cask conflicts
```
Error: Cask 'app' is already installed
```
Solution:
```bash
# Reinstall
brew reinstall --cask app

# Or remove from Brewfile if already installed manually
```

#### Tap not found
```
Error: Invalid tap name
```
Solution:
```ruby
# Use full tap URL
tap "user/repo", "https://github.com/user/repo"
```

#### MAS authentication
```
Error: The 'mas' formula is not installed
```
Solution:
```bash
# Install mas first
brew install mas

# Sign in to App Store
mas signin email@example.com
```

### Debugging
```bash
# Verbose output
brew bundle -v

# Debug mode
brew bundle --debug

# See all options
brew bundle --help
```

## Best practices

### Organization
1. **Comment sections**: Group related packages
2. **Alphabetize**: Keep packages sorted for easy maintenance
3. **Regular updates**: Keep Brewfile in sync with system
4. **Version control**: Track changes in git
5. **Documentation**: Add comments explaining why packages are needed

### Maintainability
```ruby
# Good: Organized with comments
# ===== Development Tools =====
brew "git"      # Version control
brew "gh"       # GitHub CLI
brew "node"     # JavaScript runtime

# Bad: No organization
brew "git"
brew "google-chrome"
brew "node"
cask "slack"
```

### Security
1. **Review before install**: Check what Brewfile will install
2. **Verify sources**: Only use trusted taps
3. **Keep updated**: Regular `brew update && brew upgrade`
4. **Check signatures**: Use `require_sha` for sensitive apps

### Performance
```bash
# Parallel installation (Homebrew does this by default)
brew bundle

# Skip dependencies check for faster execution
brew bundle --no-upgrade

# Only install missing packages
brew bundle --no-upgrade
```

## Integration with dotfiles

### Chezmoi integration
```bash
# .chezmoiscripts/run_once_before_install-packages.sh.tmpl
#!/bin/bash
{{- if eq .chezmoi.os "darwin" }}
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file={{ .chezmoi.sourceDir }}/Brewfile
{{- end }}
```

### Makefile automation
```makefile
# Makefile
.PHONY: install update clean

install:
	brew bundle

update:
	brew update
	brew upgrade
	brew bundle dump --force

clean:
	brew bundle cleanup --force
	brew cleanup

check:
	brew bundle check
```

### Shell script wrapper
```bash
#!/bin/bash
# install.sh

set -e

echo "Installing Homebrew packages..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install from Brewfile
brew bundle --file="${HOME}/dotfiles/Brewfile"

echo "Installation complete!"
```

## Tips and tricks

### List packages by type
```bash
# List formulae
brew bundle list --brews

# List casks
brew bundle list --casks

# List taps
brew bundle list --taps

# List MAS apps
brew bundle list --mas
```

### Diff installed vs Brewfile
```bash
# Check what's installed but not in Brewfile
brew bundle cleanup --dry-run

# Show missing packages
brew bundle check --verbose
```

### Multiple Brewfiles
```bash
# Install from multiple files
brew bundle --file=Brewfile.common
brew bundle --file=Brewfile.dev
brew bundle --file=Brewfile.work
```

### Exclude packages
```ruby
# Use comments to disable temporarily
# brew "package-name"  # Disabled for now

# Or remove and track in git history
```

## Example complete Brewfile

```ruby
# ~/dotfiles/Brewfile
# macOS package management with Homebrew Bundle

# ===== Taps =====
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"
tap "homebrew/services"

# ===== CLI Essentials =====
brew "mas"              # Mac App Store CLI
brew "git"              # Version control
brew "gh"               # GitHub CLI
brew "vim"              # Text editor
brew "zsh"              # Shell
brew "tmux"             # Terminal multiplexer

# ===== Modern CLI Tools =====
brew "bat"              # Better cat
brew "exa"              # Better ls
brew "fd"               # Better find
brew "ripgrep"          # Better grep
brew "fzf"              # Fuzzy finder
brew "jq"               # JSON processor
brew "yq"               # YAML processor
brew "delta"            # Better diff
brew "tldr"             # Simplified man pages
brew "tree"             # Directory tree
brew "htop"             # Process monitor

# ===== Development =====
brew "node"             # JavaScript
brew "python@3.11"      # Python
brew "go"               # Go
brew "rust"             # Rust
brew "docker"           # Containerization
brew "docker-compose"   # Multi-container apps
brew "terraform"        # Infrastructure as code
brew "ansible"          # Automation

# ===== Databases =====
brew "postgresql@14", restart_service: true
brew "redis", start_service: true
brew "sqlite"

# ===== Terminal & Shell =====
cask "iterm2"           # Terminal emulator
cask "warp"             # Modern terminal
brew "starship"         # Shell prompt
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ===== Editors & IDEs =====
cask "visual-studio-code"
cask "sublime-text"

# ===== Productivity =====
cask "alfred"           # Launcher
cask "rectangle"        # Window manager
cask "notion"           # Notes
mas "Things 3", id: 904280696

# ===== Communication =====
cask "slack"
cask "discord"
cask "zoom"

# ===== Browsers =====
cask "google-chrome"
cask "firefox"

# ===== Utilities =====
cask "1password"        # Password manager
cask "dropbox"          # File sync
cask "the-unarchiver"   # Archive utility
cask "appcleaner"       # App uninstaller

# ===== Fonts =====
cask "font-fira-code"
cask "font-jetbrains-mono"
cask "font-hack-nerd-font"

# ===== VS Code Extensions =====
vscode "ms-python.python"
vscode "golang.go"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
```

## Resources

When helping with Brewfiles:
- Organize packages logically with comments
- Recommend modern CLI alternatives
- Suggest service management for databases
- Encourage regular `brew bundle cleanup`
- Remind about `brew bundle check` before applying changes
- Consider using mas for Mac App Store apps
- Suggest version pinning for critical dependencies
- Document why packages are needed
