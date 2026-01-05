---
name: chezmoi-expert
description: Expert in chezmoi dotfiles manager, templates, encryption, and cross-platform dotfile management. Use when working with chezmoi configurations, dotfiles, templates, or when the user asks about managing dotfiles, chezmoi commands, or configuration synchronization.
allowed-tools: Read, Grep, Glob, Bash
---

# Chezmoi Expert

An expert skill for working with chezmoi, the dotfile manager that handles templates, encryption, and cross-platform configurations.

## When to use this skill

Use this skill when:
- Managing dotfiles with chezmoi
- Creating or updating chezmoi templates
- Working with encrypted secrets in dotfiles
- Setting up cross-platform configurations
- Debugging chezmoi issues
- Migrating to or from chezmoi

## Core concepts

### Directory structure
```
~/.local/share/chezmoi/      # Source directory
  .chezmoi.toml.tmpl          # Config template
  .chezmoiignore              # Files to ignore
  .chezmoiremove              # Files to remove
  .chezmoiversion             # Minimum version
  dot_bashrc                  # ~/.bashrc
  dot_config/
    private_git/
      config.tmpl             # Template file
    encrypted_private_ssh/
      private_key.asc         # Encrypted file
  run_once_install-packages.sh # Run once script
  run_onchange_setup.sh       # Run on change script
```

### Filename conventions
- `dot_` → `.` (dot_bashrc → .bashrc)
- `private_` → private file (600 permissions)
- `encrypted_` → encrypted file
- `executable_` → executable file
- `symlink_` → symbolic link
- `run_once_` → run script once
- `run_onchange_` → run when content changes
- `modify_` → modify existing file with script

## Quick start

### Initialize chezmoi
```bash
# Initialize with existing dotfiles
chezmoi init

# Initialize from GitHub repo
chezmoi init https://github.com/username/dotfiles.git

# Initialize and apply
chezmoi init --apply username
```

### Basic workflow
```bash
# Add a file to chezmoi
chezmoi add ~/.bashrc

# Edit a file (opens in $EDITOR)
chezmoi edit ~/.bashrc

# See what changes would be made
chezmoi diff

# Apply changes
chezmoi apply

# Update from source and apply
chezmoi update
```

## Templates

### Basic templating
Templates use Go's `text/template` syntax:

```bash
# dot_gitconfig.tmpl
[user]
    name = {{ .name }}
    email = {{ .email }}
{{- if eq .chezmoi.os "darwin" }}
    # macOS specific
    helper = osxkeychain
{{- end }}
```

### Config data
Define data in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    name = "John Doe"
    email = "john@example.com"

[data.github]
    user = "johndoe"
```

### Available template variables
```go
{{ .chezmoi.os }}              # darwin, linux, windows
{{ .chezmoi.arch }}            # amd64, arm64, etc.
{{ .chezmoi.hostname }}        # machine hostname
{{ .chezmoi.username }}        # current user
{{ .chezmoi.homeDir }}         # home directory
{{ .chezmoi.osRelease }}       # OS version info
{{ .chezmoi.kernel }}          # kernel info
{{ .chezmoi.fqdnHostname }}    # fully qualified hostname
```

### Template functions
```go
# Conditionals
{{- if eq .chezmoi.os "darwin" }}
macOS specific content
{{- else if eq .chezmoi.os "linux" }}
Linux specific content
{{- end }}

# Lookups
{{ lookPath "brew" }}          # Find binary in PATH
{{ output "command" "arg" }}   # Run command and get output

# String operations
{{ .name | upper }}            # JOHN DOE
{{ .name | lower }}            # john doe
{{ .name | trim }}             # Remove whitespace

# File operations
{{ include "file.txt" }}       # Include file contents
{{ includeTemplate "file.tmpl" . }} # Include template

# JSON/YAML parsing
{{ (index (fromJson (include "data.json")) "key") }}
```

## Encryption

### Using age (recommended)
```bash
# Install age
brew install age

# Generate key
age-keygen -o ~/.config/chezmoi/key.txt

# Configure chezmoi to use age
# ~/.config/chezmoi/chezmoi.toml
[encryption]
    command = "age"
    suffix = "age"
[encryption.args]
    decrypt = ["--decrypt", "--identity", "/path/to/key.txt"]
    encrypt = ["--encrypt", "--recipient", "age1..."]
```

### Add encrypted files
```bash
# Add encrypted file
chezmoi add --encrypt ~/.ssh/id_rsa

# This creates:
# encrypted_private_dot_ssh/private_id_rsa.age

# Edit encrypted file
chezmoi edit --decrypt ~/.ssh/id_rsa
```

### Using GPG
```toml
# ~/.config/chezmoi/chezmoi.toml
[encryption]
    command = "gpg"
    suffix = "asc"
[encryption.args]
    decrypt = ["--decrypt", "--quiet"]
    encrypt = ["--armor", "--recipient", "your@email.com", "--encrypt"]
```

## Scripts

### Run once scripts
```bash
# run_once_install-packages.sh.tmpl
#!/bin/bash
{{- if eq .chezmoi.os "darwin" }}
brew install git vim tmux
{{- else if eq .chezmoi.os "linux" }}
sudo apt-get install -y git vim tmux
{{- end }}
```

### Run on change scripts
```bash
# run_onchange_install-packages.sh
#!/bin/bash
# This script runs whenever its content changes

# Update packages
brew bundle --file=Brewfile
```

### Before/After scripts
```bash
# .chezmoiscripts/run_before_install.sh
# Runs before apply

# .chezmoiscripts/run_after_setup.sh
# Runs after apply
```

## Cross-platform configurations

### OS-specific files
```bash
# Suffix approach
dot_bashrc.darwin        # Only on macOS
dot_bashrc.linux         # Only on Linux

# Template approach
dot_bashrc.tmpl
{{- if eq .chezmoi.os "darwin" }}
export PATH="/opt/homebrew/bin:$PATH"
{{- else if eq .chezmoi.os "linux" }}
export PATH="/usr/local/bin:$PATH"
{{- end }}
```

### Distribution-specific
```bash
# dot_bashrc.tmpl
{{- if eq .chezmoi.osRelease.id "ubuntu" }}
# Ubuntu specific
{{- else if eq .chezmoi.osRelease.id "arch" }}
# Arch specific
{{- end }}
```

## Advanced features

### External sources
```toml
# .chezmoiexternal.toml
[".oh-my-zsh"]
    type = "archive"
    url = "https://github.com/ohmyzsh/ohmyzsh/archive/master.tar.gz"
    stripComponents = 1
    refreshPeriod = "168h"

[".vim/autoload/plug.vim"]
    type = "file"
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    refreshPeriod = "168h"
```

### Modify scripts
```bash
# modify_private_dot_ssh_config.tmpl
#!/bin/bash

# Read existing config
cat

# Append additional config
{{- range .hosts }}
Host {{ .name }}
    HostName {{ .hostname }}
    User {{ .user }}
{{- end }}
```

### Ignore files
```bash
# .chezmoiignore
README.md
LICENSE
*.swp

# Conditional ignores
{{- if ne .chezmoi.os "darwin" }}
Library/
{{- end }}
```

### Remove files
```bash
# .chezmoiremove
# Files to remove from target
old_config.conf
deprecated_script.sh
```

## Configuration file

### Complete example
```toml
# ~/.config/chezmoi/chezmoi.toml
[data]
    name = "John Doe"
    email = "john@example.com"

[data.packages]
    common = ["git", "vim", "tmux"]
    macos = ["brew", "iterm2"]

[edit]
    command = "nvim"

[diff]
    command = "delta"
    args = ["--side-by-side"]

[merge]
    command = "nvim"
    args = ["-d"]

[encryption]
    command = "age"
    suffix = "age"

[encryption.args]
    decrypt = ["--decrypt", "--identity", "~/.config/chezmoi/key.txt"]
    encrypt = ["--encrypt", "--recipient", "age1..."]

[git]
    autoCommit = true
    autoPush = true

[cd]
    command = "zsh"
```

## Common workflows

### Daily usage
```bash
# Edit a file
chezmoi edit ~/.bashrc

# See changes before applying
chezmoi diff

# Apply changes
chezmoi apply -v

# Add new file
chezmoi add ~/.vimrc

# Update from repo and apply
chezmoi update
```

### Working with secrets
```bash
# Add encrypted file
chezmoi add --encrypt ~/.netrc

# View decrypted content
chezmoi cat ~/.netrc

# Edit encrypted file
chezmoi edit --decrypt ~/.netrc
```

### Machine-specific configurations

#### Using host-specific data files (recommended)
```bash
# Create per-host data files in source directory
home/.chezmoidata_work-laptop.yaml
home/.chezmoidata_personal-mac.yaml
```

```yaml
# .chezmoidata_work-laptop.yaml
type: "work"
email: "work@company.com"
name: "Your Name"
repoPath: "/Users/you/repos/dotfiles"
```

```go
# .chezmoi.toml.tmpl - loads host file automatically
{{- $hostFile := printf ".chezmoidata_%s.yaml" .chezmoi.hostname -}}
{{- $hostData := include $hostFile | fromYaml -}}

{{- if not $hostData.type -}}
{{-   fail (printf "Unknown hostname '%s'. Create .chezmoidata_%s.yaml" .chezmoi.hostname .chezmoi.hostname) -}}
{{- end -}}

sourceDir = "{{ $hostData.repoPath }}/home"

[data]
    machineType = {{ $hostData.type | quote }}
    email = {{ $hostData.email | quote }}
    name = {{ $hostData.name | quote }}
```

#### Using conditionals in template
```toml
# chezmoi.toml.tmpl - inline approach
[data]
    {{- if eq .chezmoi.hostname "work-laptop" }}
    email = "work@company.com"
    {{- else }}
    email = "personal@example.com"
    {{- end }}
```

## Troubleshooting

### Debug mode
```bash
# Verbose output
chezmoi apply -v

# Very verbose
chezmoi apply -vv

# See template output
chezmoi execute-template < template.tmpl

# Dump all variables
chezmoi data
```

### Common issues

#### Templates not rendering
```bash
# Check template syntax
chezmoi execute-template < dot_file.tmpl

# Verify data
chezmoi data | grep variable_name
```

#### Permission issues
```bash
# Re-add file with correct attributes
chezmoi add --template ~/.bashrc

# For executable files
chezmoi add --executable script.sh
```

#### Merge conflicts
```bash
# Use merge tool
chezmoi merge ~/.bashrc

# Or manually resolve
chezmoi diff ~/.bashrc
chezmoi edit ~/.bashrc
chezmoi apply
```

## Best practices

### Organization
1. Use templates for cross-platform configs
2. Encrypt sensitive data
3. Use scripts for one-time setup tasks
4. Keep source directory clean and well-organized
5. Document with README.md in source directory

### Security
1. Never commit unencrypted secrets
2. Use age encryption (simpler than GPG)
3. Keep encryption keys secure
4. Use private_ prefix for sensitive files
5. Add `.env` files to `.chezmoiignore`

### Templates
1. Keep templates simple and readable
2. Test on all target platforms
3. Use comments to explain complex logic
4. Prefer OS detection over hostname detection
5. Use external data for machine-specific values

### Git integration
```bash
# Auto-commit and push
chezmoi git add .
chezmoi git commit -- -m "Update configs"
chezmoi git push

# Or enable autoCommit in config
[git]
    autoCommit = true
    autoPush = true
```

### Testing changes
```bash
# Always diff before apply
chezmoi diff

# Test in temporary directory
chezmoi init --apply --destination=/tmp/test username

# Dry run
chezmoi apply --dry-run -v
```

## Migration

### From existing dotfiles
```bash
# Initialize repo
cd ~/.local/share/chezmoi
git init

# Add files one by one
chezmoi add ~/.bashrc
chezmoi add ~/.vimrc
chezmoi add ~/.config/nvim/init.vim

# Review and commit
chezmoi cd
git add .
git commit -m "Initial commit"
```

### From other managers
```bash
# From GNU Stow
# Files are already in home directory
chezmoi add ~/.bashrc
chezmoi add ~/.vimrc

# From yadm
# Convert yadm templates to chezmoi format
# yadm uses ##class syntax
# chezmoi uses {{.chezmoi.os}} syntax
```

## Integration

### With 1Password
```toml
# Use 1Password CLI
{{ (onepasswordRead "op://vault/item/field") }}
```

### With pass
```bash
{{ (output "pass" "path/to/secret") | trim }}
```

### With Bitwarden
```bash
{{ (output "bw" "get" "password" "item-id") | trim }}
```

## Critical Best Practices (Lessons Learned)

### Template File Naming
**CRITICAL**: Files containing template variables MUST have the `.tmpl` extension:
```bash
# ❌ WRONG - will fail with "map has no entry for key"
run_once_install.sh           # Contains {{ .chezmoi.sourceDir }}

# ✅ CORRECT
run_once_install.sh.tmpl      # Chezmoi processes templates
```

Without `.tmpl`, chezmoi treats the file as plain text and doesn't process template variables.

### Non-Interactive Bootstrap Integration

When integrating chezmoi with bootstrap scripts, provide all required data upfront:

```bash
# Create chezmoi config before apply
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
[data]
    email = "$GIT_EMAIL"
    name = "$GIT_NAME"
    githubUsername = "$GITHUB_USER"
    machineType = "$MACHINE_TYPE"

[data.onepassword]
    enabled = true
EOF

# Then apply
chezmoi apply
```

**Why**: `promptStringOnce` in `.chezmoi.toml.tmpl` won't work in non-interactive environments.

### Script Path Detection

Scripts in `.chezmoiscripts/` must handle multiple possible locations:

```bash
# ✅ CORRECT - check multiple locations
BREWFILE_DIR=""
for dir in "{{ .chezmoi.sourceDir }}/.." "$HOME/.dotfiles" "{{ .chezmoi.sourceDir }}/../../dotfiles"; do
    if [ -f "$dir/Brewfile" ]; then
        BREWFILE_DIR="$dir"
        break
    fi
done

if [ -z "$BREWFILE_DIR" ]; then
    echo "Brewfile not found. Skipping."
    exit 0
fi
```

**Why**: `{{ .chezmoi.sourceDir }}` varies depending on how chezmoi was initialized (repo clone vs local init).

### Template Variable Escaping

When you want literal template syntax in output (like showing examples):

```bash
# ❌ WRONG - chezmoi will try to evaluate
# GITHUB_TOKEN={{ onepasswordRead "op://Private/token" }}

# ✅ CORRECT - escape the template syntax
# GITHUB_TOKEN={{ "{{" }} onepasswordRead "op://Private/token" {{ "}}" }}
```

### Bootstrap Script Integration

When copying dotfiles from a repo to chezmoi source:

```bash
# If chezmoi init cloned a repo with home/ subdirectory
if [ -d "$CHEZMOI_SOURCE_DIR/home" ]; then
    # Move files from home/ to root
    cp -r "$CHEZMOI_SOURCE_DIR/home/"* "$CHEZMOI_SOURCE_DIR/"
    rm -rf "$CHEZMOI_SOURCE_DIR/home"
fi

# Always copy local files to get latest changes (overwrite repo version)
if [ -d "home" ]; then
    cp -r home/* "$CHEZMOI_SOURCE_DIR/"
fi
```

**Why**: When `chezmoi init` clones from a repo, it may create a nested structure that needs flattening.

## Resources

When helping with chezmoi:
- **ALWAYS** check that template files have `.tmpl` extension
- Emphasize template-based configuration for cross-platform setups
- Recommend age for encryption (simpler than GPG)
- Suggest proper file naming conventions
- Encourage use of scripts for setup automation
- Always test with `chezmoi diff` before `chezmoi apply`
- Remind about `.chezmoiignore` for repo-specific files
- Consider security implications of dotfile exposure
- Provide all data upfront for non-interactive usage
- Handle multiple possible path locations in scripts
