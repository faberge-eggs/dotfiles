# Workato Machine Configuration Guide

This guide explains how to set up and manage workato-specific configurations using the dotfiles automation system.

## Overview

The dotfiles system supports **machine-specific configurations** to handle differences between personal and workatoato machines. This includes:

- **Separate package lists** (`Brewfile.workato`)
- **Work-specific dotfiles** (templated configurations)
- **Conditional git configuration** (workato email, SSH keys)
- **Work-specific Ansible tasks** (`playbook.workato.yml`)
- **Environment-based settings** (cloud profiles, VPNs, proxies)

## Initial Setup

### During Bootstrap

When you run `bootstrap.sh`, it will ask:

```bash
Is this a workato machine? (y/N):
```

Answer `y` for workato machines. This will:
1. Set `machineType = "workato"` in chezmoi config
2. Install packages from both `Brewfile` and `Brewfile.workato`
3. Apply workato-specific dotfile templates
4. Run both `playbook.yml` and `playbook.workato.yml`

### Manual Configuration

If you already ran bootstrap, you can set machine type manually:

```bash
# Edit chezmoi data
chezmoi data

# You should see machineType in the output
# To change it, edit:
vim ~/.config/chezmoi/chezmoi.toml
```

## Work-Specific Files

### 1. Brewfile.workato

Location: `dotfiles/Brewfile.workato`

Add workato-specific packages here:

```ruby
# Cloud Provider CLIs
brew "awscli"
brew "azure-cli"
brew "google-cloud-sdk"

# Corporate Tools
cask "microsoft-teams"
cask "slack"
cask "zoom"

# VPN
cask "cisco-anyconnect"

# Security
brew "vault"
brew "aws-vault"
```

After editing:
```bash
brew bundle --file=Brewfile.workato
```

### 2. Zsh Configuration

Location: `home/dot_zshrc.tmpl`

Work-specific section (automatically included for workato machines):

```bash
{{- if eq .machineType "workato" }}
# Cloud Provider Profiles
export AWS_PROFILE="workato"
export AWS_REGION="us-east-1"

# Corporate Proxies
export HTTP_PROXY="http://proxy.company.com:8080"
export HTTPS_PROXY="http://proxy.company.com:8080"
export NO_PROXY="localhost,127.0.0.1,.company.com"

# Work-specific aliases
alias vpn-connect="sudo openconnect vpn.company.com"
alias vpn-disconnect="sudo killall openconnect"
{{- end }}
```

Customize by editing:
```bash
chezmoi edit ~/.zshrc
```

### 3. Git Configuration

Work machines get special git handling:

#### Directory-Based Email

Location: `home/dot_gitconfig.tmpl`

```ini
# Use workato email for repos in ~/workato/
[includeIf "gitdir:~/workato/"]
    path = ~/.gitconfig.workato
```

#### Workato Git Config

Location: `~/.gitconfig.workato`

```ini
[user]
    email = your.name@workato.com

[core]
    sshCommand = ssh -i ~/.ssh/workatoato_id_rsa
```

#### Usage

```bash
# Personal projects (uses personal email)
cd ~/Developer/personal-project
git config user.email  # your@personal.com

# Work projects (uses workato email)
cd ~/workato/workato-project
git config user.email  # your.name@workato.com
```

### 4. Environment Variables

Location: `~/.workato.env` (created by Ansible)

```bash
# Work-specific environment variables
export AWS_PROFILE="work-account"
export AWS_REGION="us-east-1"
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export GCP_PROJECT="workato-project-id"
export COMPANY_ENV="production"
```

Load in shell:
```bash
source ~/.workato.env
```

Or add to `~/.zshrc.local`:
```bash
[ -f ~/.workato.env ] && source ~/.workato.env
```

### 5. 1Password for Work Secrets

Use 1Password to store work secrets securely:

```bash
# Sign in to workato 1Password account
eval $(op signin work)

# Store secrets
op item create --category=Login \
  --title="Work AWS" \
  AWS_ACCESS_KEY_ID=AKIA... \
  AWS_SECRET_ACCESS_KEY=secret...

# Use in templates
# In dot_env.tmpl:
# AWS_ACCESS_KEY_ID={{ onepasswordRead "op://Work/Work AWS/AWS_ACCESS_KEY_ID" }}
```

### 6. Ansible Work Configuration

Location: `playbook.workato.yml`

Configures workato-specific system settings:

```yaml
- name: Configure Workato Machine
  tasks:
    - name: Create work directories
      file:
        path: "{{ item }}"
        state: directory
      loop:
        - ~/workato/projects
        - ~/workato/docs

    - name: Install corporate certificates
      copy:
        src: files/company-root-ca.crt
        dest: /usr/local/share/ca-certificates/
      become: yes

    - name: Configure VPN
      template:
        src: templates/vpn-config.ovpn
        dest: ~/.vpn/work-vpn.ovpn
```

Run manually:
```bash
ansible-playbook playbook.workato.yml --ask-become-pass
```

## Common Work Scenarios

### Scenario 1: Different Git Emails

**Problem**: Use workato email for workato repos, personal email for personal repos

**Solution**: Directory-based includes

```bash
# 1. Organize projects by directory
~/Developer/        # Personal projects
~/workato/            # Work projects

# 2. Git auto-detects and uses correct email
cd ~/Developer/my-project
git config user.email  # personal@example.com

cd ~/workato/workato-project
git config user.email  # your.name@workato.com
```

### Scenario 2: Corporate VPN

**Problem**: Need to connect to corporate VPN

**Solution**: Add VPN package and aliases

1. Add to `Brewfile.workato`:
```ruby
cask "cisco-anyconnect"
# or
brew "openconnect"
```

2. Add aliases to work section in `.zshrc`:
```bash
alias vpn-connect="sudo openconnect vpn.company.com --user=yourname"
alias vpn-status="ps aux | grep openconnect"
alias vpn-disconnect="sudo killall openconnect"
```

### Scenario 3: Cloud Provider Profiles

**Problem**: Multiple AWS/Azure/GCP accounts (personal + work)

**Solution**: Environment-based profiles

1. Add to work section in `.zshrc`:
```bash
export AWS_PROFILE="workato"
export AWS_REGION="us-east-1"

# Aliases to switch profiles
alias aws-work="export AWS_PROFILE=work"
alias aws-personal="export AWS_PROFILE=personal"
```

2. Configure AWS:
```bash
aws configure --profile work
aws configure --profile personal
```

### Scenario 4: Corporate Proxy

**Problem**: Need proxy for network access

**Solution**: Proxy environment variables

Add to work section in `.zshrc`:
```bash
export HTTP_PROXY="http://proxy.company.com:8080"
export HTTPS_PROXY="http://proxy.company.com:8080"
export NO_PROXY="localhost,127.0.0.1,.internal.company.com"

# Git proxy
git config --global http.proxy http://proxy.company.com:8080
git config --global https.proxy http://proxy.company.com:8080

# npm proxy
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080
```

### Scenario 5: Company-Specific Tools

**Problem**: Need workato CLI tools or internal packages

**Solution**: Add to work Brewfile and configs

1. Add company tap:
```ruby
# Brewfile.workato
tap "company/internal"
brew "company-cli"
cask "company-vpn"
```

2. Configure in Ansible:
```yaml
# playbook.workato.yml
- name: Configure workato CLI
  template:
    src: templates/company-config.yml
    dest: ~/.company/config.yml
```

### Scenario 6: SSH Keys for Work

**Problem**: Separate SSH keys for workato repositories

**Solution**: SSH config and git settings

1. Generate work SSH key:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/workatoato_id_ed25519 -C "your.name@workato.com"
```

2. Add to `~/.ssh/config`:
```
# Workato GitHub Enterprise
Host github.company.com
    HostName github.company.com
    User git
    IdentityFile ~/.ssh/workatoato_id_ed25519

# Personal GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
```

3. Configure in `~/.gitconfig.workato`:
```ini
[core]
    sshCommand = ssh -i ~/.ssh/workatoato_id_ed25519
```

## Maintenance

### Update Work Packages

```bash
# Update Brewfile.workato from installed packages
brew bundle dump --file=Brewfile.workato --force

# Install new work packages
brew bundle --file=Brewfile.workato
```

### Test Work Configuration

```bash
# Check machine type
chezmoi data | grep machineType

# Test templates
chezmoi execute-template < home/dot_zshrc.tmpl | grep -A 10 "Workato Machine"

# Verify workato-specific settings
echo $AWS_PROFILE
git config user.email
```

### Switch Machine Type

If you need to change machine type:

```bash
# Edit chezmoi config
vim ~/.config/chezmoi/chezmoi.toml

# Change machineType from "personal" to "workato" or vice versa

# Re-apply dotfiles
chezmoi apply -v
```

## Security Best Practices

### 1. Never Commit Secrets

❌ Don't commit to dotfiles:
- API keys
- Passwords
- Private SSH keys
- Corporate certificates
- VPN configs with credentials

✅ Use instead:
- 1Password CLI for secrets
- `.gitignore` for sensitive files
- Chezmoi encryption for truly necessary secrets
- Local `.local` files (not synced)

### 2. Use Separate SSH Keys

```bash
# Personal: ~/.ssh/id_ed25519
# Work: ~/.ssh/workatoato_id_ed25519

# Never share keys between personal and workato
```

### 3. Separate 1Password Vaults

```bash
# Personal vault
eval $(op signin personal)

# Work vault
eval $(op signin work)
```

### 4. Review Changes Before Committing

```bash
# Always check diffs before committing
chezmoi diff

# Ensure no work secrets are in templates
git diff Brewfile.workato
```

## Troubleshooting

### Work Packages Not Installing

```bash
# Check if Brewfile.workato exists
ls -la Brewfile.workato

# Verify machine type
chezmoi data | grep machineType

# Manually install
brew bundle --file=Brewfile.workato
```

### Wrong Git Email

```bash
# Check current email
git config user.email

# Check what git config file is being used
git config --show-origin user.email

# Verify includeIf is working
git config --list --show-origin | grep includeIf
```

### Workato Environment Not Loading

```bash
# Check if .workato.env exists
ls -la ~/.workato.env

# Source manually
source ~/.workato.env

# Add to .zshrc.local for auto-loading
echo '[ -f ~/.workato.env ] && source ~/.workato.env' >> ~/.zshrc.local
```

## Tips

1. **Keep work configs commented** - Document why each workato-specific setting exists
2. **Use .local files** - For truly machine-specific configs that shouldn't sync
3. **Test on VM first** - Before applying to production workato machine
4. **Separate 1Password accounts** - Keep work and personal secrets isolated
5. **Regular audits** - Review work configs periodically for outdated settings

## Example: Complete Work Setup

```bash
# 1. Bootstrap as workato machine
./bootstrap.sh
# Answer 'y' when asked "Is this a workato machine?"

# 2. Configure work packages
vim Brewfile.workato
# Add: brew "awscli", cask "slack", etc.
brew bundle --file=Brewfile.workato

# 3. Set work git email
vim ~/.gitconfig.workato
# [user]
#     email = your.name@workato.com

# 4. Configure work environment
vim ~/.workato.env
# export AWS_PROFILE="workato"
source ~/.workato.env

# 5. Set up work SSH
ssh-keygen -t ed25519 -f ~/.ssh/workatoato_id_ed25519
# Add to ~/.ssh/config and ~/.gitconfig.workato

# 6. Create work directories
mkdir -p ~/workato/{projects,docs}

# 7. Test
cd ~/workato/test-repo
git config user.email  # Should show your.name@workato.com
echo $AWS_PROFILE       # Should show "workato"
```

---

**Questions?** Check the main [README.md](README.md) or open an issue.
