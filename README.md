# Dotfiles

Automated macOS setup using Homebrew, Chezmoi, and Ansible for reproducible system configuration.

## Features

- **One-command setup** - Bootstrap a new Mac in minutes
- **Package management** - Declarative Brewfile for all software
- **Dotfile management** - Chezmoi with templating and 1Password integration
- **System configuration** - Ansible playbook for macOS defaults
- **Cross-platform** - Templates adapt to different machines
- **Secure** - 1Password CLI for secrets management
- **Maintainable** - Makefile with convenient commands

## Quick Start

### New Machine Setup

Run this single command to set up everything:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/bootstrap.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

### What Gets Installed

#### Development Tools
- Git, GitHub CLI, Docker, Docker Compose
- Node.js, Python, Go, Rust, Ruby
- PostgreSQL, MySQL, Redis, SQLite
- Terraform, Ansible, Kubernetes CLI

#### Modern CLI Utilities
- `bat` (better cat), `eza` (better ls), `ripgrep` (better grep)
- `fd` (better find), `fzf` (fuzzy finder), `delta` (better diff)
- `htop`, `btop`, `ncdu`, `jq`, `yq`

#### GUI Applications
- Visual Studio Code, Docker Desktop, iTerm2
- Google Chrome, Firefox, Brave
- Alfred, Rectangle, Notion
- 1Password, Slack, Zoom

#### Fonts
- Fira Code, JetBrains Mono, Hack Nerd Font
- Cascadia Code, Source Code Pro

## Project Structure

```
dotfiles/
├── bootstrap.sh              # Main setup script
├── Brewfile                  # Homebrew packages
├── Makefile                  # Convenience commands
├── playbook.yml              # Ansible playbook for macOS config
├── ansible.cfg               # Ansible configuration
├── inventory                 # Ansible inventory
├── README.md                 # This file
│
└── home/                     # Chezmoi source directory
    ├── .chezmoi.toml.tmpl   # Chezmoi configuration
    ├── .chezmoiignore       # Files to ignore
    │
    ├── dot_zshrc.tmpl       # Zsh configuration
    ├── dot_gitconfig.tmpl   # Git configuration
    ├── dot_gitignore_global # Global gitignore
    ├── dot_env.tmpl         # Environment variables
    │
    ├── dot_config/
    │   └── starship/
    │       └── starship.toml # Starship prompt config
    │
    ├── private_dot_ssh/     # SSH config (private)
    │
    └── .chezmoiscripts/
        ├── run_once_before_install-brew.sh
        └── run_onchange_after_install-packages.sh
```

## Daily Usage

### Makefile Commands

The Makefile provides convenient shortcuts:

```bash
make help          # Show all available commands
make install       # Full installation
make update        # Update everything
make config        # Run Ansible configuration
make check         # Health check
make clean         # Clean up old packages
```

### Updating Packages

```bash
# Update everything (Homebrew, packages, dotfiles)
make update

# Update just Homebrew packages
make update-brew

# Update just dotfiles
make update-dotfiles
```

### Managing Dotfiles

```bash
# Edit a dotfile
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Quick apply
make apply
```

### Adding New Packages

```bash
# Install package
brew install package-name

# Add to Brewfile
make update-brewfile

# Commit changes
make commit
```

## Components

### 1. Bootstrap Script

`bootstrap.sh` is the entry point that:
- Installs Xcode Command Line Tools
- Installs Homebrew
- Installs packages from Brewfile
- Sets up Chezmoi
- Applies dotfiles
- Runs Ansible playbook
- Configures Zsh as default shell

### 2. Homebrew Brewfile

`Brewfile` declaratively defines all packages:
- CLI tools and utilities
- GUI applications (casks)
- Fonts
- Mac App Store apps

```bash
# Install all packages
brew bundle

# Remove packages not in Brewfile
brew bundle cleanup

# Check if everything is installed
brew bundle check
```

### 3. Chezmoi Dotfiles

Chezmoi manages dotfiles with:
- **Templating** - Dynamic configs based on machine/OS
- **Encryption** - Secure sensitive files
- **Scripts** - Run commands during apply

#### File Naming Convention
- `dot_` → `.` (e.g., `dot_zshrc` → `.zshrc`)
- `private_` → 600 permissions
- `encrypted_` → encrypted file
- `executable_` → executable file
- `.tmpl` → template file

#### Chezmoi Commands
```bash
chezmoi init                    # Initialize
chezmoi add ~/.zshrc           # Add file
chezmoi edit ~/.zshrc          # Edit file
chezmoi diff                   # Show changes
chezmoi apply                  # Apply changes
chezmoi update                 # Update from repo
chezmoi cd                     # Navigate to source dir
```

### 4. 1Password Integration

Secrets are managed via 1Password CLI:

#### Setup
```bash
# Install (already in Brewfile)
brew install 1password-cli

# Sign in
eval $(op signin)

# Test
op item list
```

#### Usage in Templates

```bash
# In dot_env.tmpl
GITHUB_TOKEN={{ onepasswordRead "op://Private/GitHub/token" }}
```

#### Helper Functions (in .zshrc)

```bash
# Load a single secret
op_env "Item Name" "field_name"

# Export all secrets from an item
op_export_env "Development Environment"
```

### 5. Ansible Playbook

`playbook.yml` configures macOS system preferences:

#### What It Configures
- **Dock** - Size, autohide, recent apps
- **Finder** - Show hidden files, extensions, path bar
- **Keyboard** - Key repeat, delay
- **Trackpad** - Tap to click, three finger drag
- **Screenshots** - Location, format, no shadow
- **Safari** - Develop menu, full URL
- **System** - Disable auto-correct, smart quotes

#### Running Ansible
```bash
# Run playbook
make config

# Dry run
make ansible-check

# Direct execution
ansible-playbook playbook.yml --ask-become-pass
```

## Advanced Usage

### iTerm2 Configuration Management

iTerm2 preferences are automatically synced via this dotfiles repo.

#### How It Works

The Ansible playbook configures iTerm2 to load preferences from `config/iterm2/`, allowing you to version control your iTerm2 settings.

#### Setup (Automatic)

When you run `./bootstrap.sh`, iTerm2 is automatically configured to use the custom preferences directory.

#### Manual Setup

```bash
# Run the setup script
./scripts/setup-iterm2.sh

# Restart iTerm2
# ⌘Q to quit, then reopen
```

#### What Gets Synced

- Color schemes and themes
- Key bindings
- Profiles (fonts, colors, shell settings)
- Window arrangements
- Status bar configuration
- All iTerm2 preferences

#### Usage

1. **Make changes in iTerm2** - They auto-save to `config/iterm2/`
2. **Commit changes**:
   ```bash
   git add config/iterm2/
   git commit -m "Update iTerm2 preferences"
   git push
   ```
3. **On another machine** - Pull changes and restart iTerm2

See [config/iterm2/README.md](config/iterm2/README.md) for detailed documentation.

### Machine-Specific Configuration

Chezmoi templates can adapt to different machines:

```bash
# In dot_zshrc.tmpl
{{- if eq .chezmoi.hostname "work-laptop" }}
export AWS_PROFILE="work"
{{- end }}

{{- if eq .chezmoi.os "darwin" }}
# macOS specific config
{{- end }}
```

### Adding Encrypted Files

```bash
# Install age (already in Brewfile if using encryption)
brew install age

# Generate key
age-keygen -o ~/.config/chezmoi/key.txt

# Add encrypted file
chezmoi add --encrypt ~/.ssh/id_rsa

# Edit encrypted file
chezmoi edit --decrypt ~/.ssh/id_rsa
```

### Custom Local Configuration

Add machine-specific configs that won't be synced:

```bash
# ~/.zshrc.local (not managed by chezmoi)
export CUSTOM_VAR="value"

# ~/.gitconfig.local
[user]
    email = your.name@workato.com
```

These files are sourced automatically if they exist.

## Machine-Specific Configuration (Template Inheritance)

This setup uses **template inheritance** to keep only deltas in machine-specific files. The base `Brewfile` and `playbook.yml` contain common packages/configs, while machine-specific files contain only the differences.

### Supported Machine Types

1. **own** - Your personal machine (default)
2. **workato** - Workato work machine

This setup supports **multiple machine types** with separate configurations for machine-specific tools, packages, and settings.

### Key Features

- **Template inheritance** - Base configs + machine-specific deltas only
- **Separate Brewfiles** for each machine type (only deltas)
- **Conditional dotfiles** with machine-specific sections
- **Directory-based git config** (different emails by project location)
- **Machine-specific Ansible playbooks** (only deltas)
- **1Password integration** for secrets

### Quick Setup

When running `bootstrap.sh`, choose your machine type:

```
What type of machine is this?
  1) own (personal machine)
  2) workato (Workato work machine)
Select [1-2]:
```

This automatically:
- Sets `machineType` in chezmoi ("own" or "workato")
- Installs common packages from `Brewfile`
- Installs machine-specific packages from `Brewfile.{type}`
- Applies machine-specific dotfile sections
- Runs machine-specific Ansible tasks

### Machine-Specific Files

**Own Machine (Personal):**
```
Brewfile.own                  # Personal packages (games, personal tools)
playbook.own.yml              # Personal system configuration
home/dot_gitconfig.own.tmpl   # Personal git settings
~/.own.env                    # Personal environment variables
```

**Workato Machine:**
```
Brewfile.workato              # Workato packages (AWS CLI, Slack, VPN, etc.)
playbook.workato.yml          # Workato system configuration
home/dot_gitconfig.workato.tmpl   # Workato git settings
~/.workato.env                # Workato environment variables
```

### Example: Directory-Based Git Emails

```bash
# Personal projects (own machine)
cd ~/Developer/personal/my-project
git config user.email  # personal@example.com

# Workato projects
cd ~/workato/company-project
git config user.email  # your.name@workato.com

# Other projects use default email from .gitconfig
cd ~/Developer/other-project
git config user.email  # {{ .email }} (from chezmoi config)
```

### Template Inheritance Architecture

**Base Files (Common):**
- `Brewfile` - Common packages for all machines
- `playbook.yml` - Common macOS settings for all machines
- `home/dot_zshrc.tmpl` - Common shell config with machine-specific sections

**Delta Files (Machine-Specific):**
- `Brewfile.{type}` - Additional packages for specific machine type
- `playbook.{type}.yml` - Additional Ansible tasks for specific machine type
- Conditional template sections using `{{- if eq .machineType "..." }}`

**Benefits:**
- ✅ No duplication - common configs in one place
- ✅ Easy to maintain - change common things once
- ✅ Clear deltas - see exactly what's different per machine
- ✅ Scalable - easy to add new machine types

### Learn More

See [WORKATO_MACHINE_GUIDE.md](WORKATO_MACHINE_GUIDE.md) for detailed Workato-specific documentation including:
- Workato package management
- VPN and proxy configuration
- Cloud provider profiles
- SSH keys for workato
- Security best practices
- Common workato scenarios

## Maintenance

### Regular Updates

```bash
# Weekly: Update everything
make update

# Monthly: Update Brewfile and commit
make update-brewfile
make commit
```

### Health Checks

```bash
# Run all checks
make check

# Shows:
# - Homebrew health
# - Brewfile status
# - Chezmoi verification
# - Tool versions
```

### Cleaning Up

```bash
# Clean old package versions
make clean

# Remove packages not in Brewfile
make clean-all
```

### Backup

```bash
# Backup current dotfiles
make backup

# Creates timestamped archive in backups/
```

## Troubleshooting

### Bootstrap Issues

If bootstrap fails:

```bash
# Check Xcode Command Line Tools
xcode-select -p

# Reinstall if needed
xcode-select --install

# Check Homebrew
brew doctor
```

### Chezmoi Issues

```bash
# Verify chezmoi state
chezmoi verify

# See what would change
chezmoi diff

# Force reapply
chezmoi apply --force
```

### 1Password Issues

```bash
# Check if signed in
op account list

# Sign in again
eval $(op signin)

# Test connection
op item list
```

### Ansible Issues

```bash
# Verify playbook syntax
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check

# Verbose output
ansible-playbook playbook.yml -v
```

## Testing

Test the setup without affecting your system:

```bash
# Test script syntax
make test

# Test in VM or container
# (Recommended before running on main machine)
```

## Customization

### Add More Packages

Edit `Brewfile`:

```ruby
# Add CLI tool
brew "package-name"

# Add GUI app
cask "app-name"

# Add font
cask "font-name"
```

### Modify System Settings

Edit `playbook.yml`:

```yaml
- name: Your setting name
  community.general.osx_defaults:
    domain: com.apple.domain
    key: SettingKey
    type: bool
    value: true
```

### Add More Dotfiles

```bash
# Add file to chezmoi
chezmoi add ~/.config/app/config.yml

# Edit template
chezmoi edit ~/.config/app/config.yml
```

## Best Practices

1. **Commit regularly** - Track all changes in git
2. **Test before applying** - Use `chezmoi diff` and `ansible-playbook --check`
3. **Keep secrets secure** - Use 1Password, never commit unencrypted secrets
4. **Document changes** - Add comments explaining why packages are needed
5. **Version pin carefully** - Only pin versions when necessary
6. **Clean up regularly** - Run `make clean` to remove old packages
7. **Update frequently** - Run `make update` weekly

## Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Ansible Documentation](https://docs.ansible.com/)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [Starship Documentation](https://starship.rs/)

## License

MIT License - See LICENSE file

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Credits

Built with:
- [Homebrew](https://brew.sh/) - Package management
- [Chezmoi](https://www.chezmoi.io/) - Dotfile management
- [Ansible](https://www.ansible.com/) - Configuration management
- [1Password CLI](https://developer.1password.com/docs/cli/) - Secrets management
- [Starship](https://starship.rs/) - Cross-shell prompt

---

**Happy automating!** 🚀
