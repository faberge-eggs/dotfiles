# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

macOS dotfiles management system using three integrated tools:
- **Chezmoi** - Dotfile templating and deployment
- **Homebrew** - Package management via declarative Brewfiles
- **Ansible** - macOS system configuration and preferences

Supports two machine types: `own` (personal) and `workato` (work), using a base + delta architecture where machine-specific files contain only differences.

## Rules
- **Don't edit files in `home` directory -  Use chezmoi**
- **Don't run `brew install` - only use `Brewfile`**
- **Don't run `gem install` - only use `Gemfile`**
- **Don't run `go install` - only use `go-packages.txt`**
- **Don't run `pip install` - only use `requirements.txt`**
- **Don't run `npm install -g` - only use `npm-packages.txt`**

## Common Commands

```bash
# Full setup on new machine
./bootstrap.sh

# Daily operations
make update          # Update brew, packages, and dotfiles
make apply           # Apply chezmoi dotfiles
make diff            # Preview dotfile changes

# Ansible
make ansible         # Run macOS configuration (prompts for sudo)
make ansible-check   # Dry-run Ansible

# Package management
make install-brew    # Install from Brewfile
make update-brewfile # Dump installed packages to Brewfile
make clean-all       # Remove packages not in Brewfile

# Health checks
make doctor          # Check brew, chezmoi, git, 1Password CLI
make test            # Syntax check bootstrap.sh and playbook.yml
```

## Architecture

### Chezmoi Structure (`home/`)

Templates use Go text/template syntax with chezmoi data:
- `.machineType` - "own" or "workato"
- `.name`, `.email`, `.githubUsername` - User identity
- `onepasswordRead` - 1Password CLI integration for secrets

File naming conventions:
- `dot_` prefix becomes `.` (dot_zshrc → .zshrc)
- `private_` sets 600 permissions
- `.tmpl` suffix enables templating

Key templates:
- `dot_zshrc.tmpl` - Shell config with machine-conditional sections
- `dot_gitconfig.tmpl` - Git config with directory-based email switching
- `.chezmoi.toml.tmpl` - Chezmoi configuration and data prompts

### Machine-Specific Files

Base files apply to all machines. Machine-specific deltas:

| Type | Brewfile | Playbook | Git Config |
|------|----------|----------|------------|
| own | `Brewfile.own` | `playbook.own.yml` | `dot_gitconfig.own.tmpl` |
| workato | `Brewfile.workato` | `playbook.workato.yml` | `dot_gitconfig.workato.tmpl` |

### Directory-Based Git Configuration

Git email switches automatically by project location:
- `~/Developer/personal/` → uses `.gitconfig.own`
- `~/workato/` → uses `.gitconfig.workato`

Implemented via git `includeIf` directives in `dot_gitconfig.tmpl`.

### 1Password Integration

Secrets retrieved via 1Password CLI in templates:
```
{{ onepasswordRead "op://Private/GitHub/token" }}
```

Shell helpers in zshrc: `op_env()`, `op_export_env()`

## Adding New Configuration

**New dotfile:**
```bash
chezmoi add ~/.config/app/config.yml
chezmoi edit ~/.config/app/config.yml  # Add templating if needed
make apply
```

**New package:**
- Homebrew: Add to `Brewfile` (or `Brewfile.{type}` for machine-specific)
- Ruby gem: Add to `Gemfile`
- Go tool: Add to `go-packages.txt`
- Python: Add to `requirements.txt`
- NPM global: Add to `npm-packages.txt`

**New macOS setting:** Add to `playbook.yml` (or `playbook.{type}.yml`)

## Claude Code Skills

This repo includes specialized Claude Code skills in `.claude/skills/`:
- `chezmoi-expert` - Chezmoi templates, encryption, dotfile management
- `ansible-expert` - Playbooks, roles, macOS configuration
- `mac-brewfile-expert` - Homebrew bundle, package management
- `neovim-expert` - Neovim config with vim-plug, LSP, treesitter
- `starship-expert` - Starship prompt configuration
- `dev-packages-expert` - Go, Ruby, Python, NPM package automation
