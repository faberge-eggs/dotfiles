---
name: dev-packages-expert
description: Expert in development package automation for Go, Ruby, Python, and NPM. Use when working with package lists, Gemfiles, requirements.txt, or automated package installation scripts.
allowed-tools: Read, Grep, Glob, Bash
---

# Development Packages Expert

An expert skill for managing development tool packages across multiple package managers with declarative configuration files.

## When to use this skill

Use this skill when:
- Adding new development tools
- Managing Go, Ruby, Python, or NPM packages
- Working with package automation scripts
- Troubleshooting package installation
- Setting up development environments

## Package Files

This repository uses declarative package files for reproducible setups:

| File | Package Manager | Purpose |
|------|----------------|---------|
| `Brewfile` | Homebrew | macOS packages and casks |
| `Gemfile` | Bundler | Ruby gems |
| `go-packages.txt` | go install | Go tools |
| `requirements.txt` | pipx | Python CLI tools |
| `npm-packages.txt` | npm -g | Node.js global packages |

## Rules

**IMPORTANT**: Never install packages directly. Always use the package files:

```bash
# WRONG - direct installation
gem install solargraph
go install golang.org/x/tools/gopls@latest
pip install black
npm install -g typescript

# CORRECT - add to package file, then apply
echo 'gem "solargraph"' >> Gemfile
chezmoi apply  # Triggers automated installation
```

## File Formats

### Gemfile (Ruby)

```ruby
# Gemfile
source "https://rubygems.org"

# LSP servers
gem "solargraph"
gem "ruby-lsp"

# Linting & formatting
gem "rubocop"
gem "rubocop-rails"
```

### go-packages.txt (Go)

```bash
# go-packages.txt
# Go tools installed with: go install <package>

# LSP
golang.org/x/tools/gopls@latest

# Linting
github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Debugging
github.com/go-delve/delve/cmd/dlv@latest

# Code generation
github.com/golang/mock/mockgen@latest

# Testing
gotest.tools/gotestsum@latest
```

### requirements.txt (Python/pipx)

```bash
# requirements.txt
# Python CLI tools installed with: pipx install <package>

# Formatting
black
isort

# Linting
pylint
mypy

# Utilities
httpie
ansible-lint
yamllint
```

### npm-packages.txt (Node.js)

```bash
# npm-packages.txt
# Global Node.js tools installed with: npm install -g

# TypeScript
typescript
ts-node

# Formatting & linting
prettier
eslint

# Utilities
npm-check-updates
```

## Automation Script

The install script runs automatically via chezmoi when package files change:

**Location**: `home/.chezmoiscripts/run_onchange_after_install-packages-dev.sh.tmpl`

### How it works

1. Chezmoi detects changes via hash comments at end of script
2. Script runs after chezmoi apply
3. Installs from all package files in order:
   - Ruby gems (bundle install)
   - Go packages (go install)
   - Python packages (pipx install)
   - NPM packages (npm install -g)

### Hash-based change detection

```bash
# At end of install script
# Gemfile hash: {{ include (joinPath .chezmoi.sourceDir "../Gemfile") | sha256sum }}
# go-packages.txt hash: {{ include (joinPath .chezmoi.sourceDir "../go-packages.txt") | sha256sum }}
# requirements.txt hash: {{ include (joinPath .chezmoi.sourceDir "../requirements.txt") | sha256sum }}
# npm-packages.txt hash: {{ include (joinPath .chezmoi.sourceDir "../npm-packages.txt") | sha256sum }}
```

When any hash changes, chezmoi re-runs the script.

## Adding New Packages

### Ruby gem

```bash
# Edit Gemfile
echo 'gem "new-gem"' >> Gemfile

# Apply changes
chezmoi apply
```

### Go tool

```bash
# Edit go-packages.txt
echo 'github.com/user/tool/cmd/tool@latest' >> go-packages.txt

# Apply changes
chezmoi apply
```

### Python tool

```bash
# Edit requirements.txt
echo 'new-tool' >> requirements.txt

# Apply changes
chezmoi apply
```

### NPM package

```bash
# Edit npm-packages.txt
echo 'new-package' >> npm-packages.txt

# Apply changes
chezmoi apply
```

## Python: pipx vs pip

**IMPORTANT**: Modern macOS prevents system-wide pip installs. Use pipx for CLI tools.

```bash
# WRONG - will fail with "externally-managed-environment"
pip install black

# CORRECT - pipx creates isolated environments
pipx install black
```

pipx:
- Creates isolated virtualenv per package
- Adds binaries to PATH
- Avoids system Python conflicts
- Perfect for CLI tools

## Ruby: Homebrew Ruby

System Ruby (2.6.x) is outdated. Use Homebrew Ruby:

```bash
# Brewfile includes
brew "ruby@3.4"

# zshrc adds to PATH
export PATH="/opt/homebrew/opt/ruby@3.4/bin:$PATH"
```

The install script automatically uses Homebrew Ruby for bundle install.

## Manual Installation

If automation isn't working, install manually:

```bash
# Ruby
cd /path/to/dotfiles
bundle install

# Go
cat go-packages.txt | grep -v '^#' | grep -v '^$' | while read pkg; do
    go install "$pkg"
done

# Python
cat requirements.txt | grep -v '^#' | grep -v '^$' | while read pkg; do
    pipx install "$pkg"
done

# NPM
cat npm-packages.txt | grep -v '^#' | grep -v '^$' | while read pkg; do
    npm install -g "$pkg"
done
```

## Troubleshooting

### Ruby gems fail

```bash
# Check Ruby version
ruby --version  # Should be 3.x from Homebrew

# Check bundler path
which bundle  # Should be /opt/homebrew/opt/ruby@3.4/bin/bundle

# Manual install
cd /path/to/dotfiles && bundle install
```

### Go packages fail

```bash
# Check Go is installed
go version

# Check GOPATH/GOBIN
go env GOPATH
go env GOBIN

# Manual install
go install golang.org/x/tools/gopls@latest
```

### Python packages fail

```bash
# Check pipx is installed
pipx --version

# List installed packages
pipx list

# Reinstall package
pipx reinstall black
```

### NPM packages fail

```bash
# Check npm prefix
npm config get prefix

# Fix permissions if needed
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# Manual install
npm install -g typescript
```

## Best Practices

1. **Always use package files** - Never install directly
2. **Pin versions for Go** - Use `@latest` or specific versions
3. **Comments for organization** - Group related packages
4. **Test after changes** - Run `chezmoi apply` and verify
5. **Keep files sorted** - Alphabetize for easy maintenance
6. **Document purpose** - Comment why each package is needed

## Package File Locations

```
dotfiles/
├── Brewfile              # Homebrew packages
├── Gemfile               # Ruby gems
├── go-packages.txt       # Go tools
├── requirements.txt      # Python tools (pipx)
├── npm-packages.txt      # NPM global packages
└── home/
    └── .chezmoiscripts/
        └── run_onchange_after_install-packages-dev.sh.tmpl
```

## Resources

When helping with packages:
- Add to appropriate package file, not direct install
- Use pipx for Python CLI tools (not pip)
- Ensure Homebrew Ruby is in PATH for gems
- Go packages need @latest or version suffix
- Run `chezmoi apply` to trigger installation
- Check script output for errors
