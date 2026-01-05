---
name: starship-expert
description: Expert in Starship cross-shell prompt configuration. Use when working with starship.toml, prompt customization, module configuration, or shell prompt styling.
allowed-tools: Read, Grep, Glob, Bash
---

# Starship Expert

An expert skill for configuring Starship, the minimal, blazing-fast, and customizable prompt for any shell.

## When to use this skill

Use this skill when:
- Configuring starship.toml
- Customizing prompt modules
- Enabling/disabling language indicators
- Setting up git status display
- Troubleshooting prompt issues

## Configuration location

```bash
~/.config/starship.toml
# or with XDG
$XDG_CONFIG_HOME/starship.toml
```

## Basic structure

```toml
# Global settings
add_newline = false

# Custom prompt format
format = """
$username$hostname$directory$git_branch$git_status
$character"""

# Module configurations
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
```

## Common modules

### Directory

```toml
[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold cyan"
read_only = " 🔒"
```

### Git

```toml
[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold red"
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
modified = "!"
staged = "[++($count)](green)"
untracked = "?"
```

### Languages

```toml
# Disable language modules
[python]
disabled = true

[ruby]
disabled = true

[nodejs]
disabled = true

# Or customize them
[golang]
symbol = " "
format = "via [$symbol($version )]($style)"
style = "bold cyan"
```

### Kubernetes

```toml
[kubernetes]
symbol = "☸ "
format = 'on [$symbol$context( \($namespace\))]($style) '
style = "cyan bold"
disabled = false

[kubernetes.context_aliases]
"dev.local.cluster.k8s" = "dev"
"gke_.*_(?P<cluster>[\\w-]+)" = "gke-$cluster"
```

### Docker

```toml
[docker_context]
symbol = " "
format = "via [$symbol$context]($style) "
style = "blue bold"
disabled = false
```

### Command duration

```toml
[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow) "
```

### Time

```toml
[time]
disabled = false
format = '🕙[\[ $time \]]($style) '
time_format = "%T"
```

## Custom format

```toml
# Two-line prompt with box drawing
format = """
[┌─](bold green)$username$hostname$directory$git_branch$git_status$docker_context
[└─❯](bold green) """

# Minimal single line
format = "$directory$git_branch$git_status$character"

# With all languages
format = """
$directory$git_branch$git_status
$python$nodejs$rust$golang$terraform$kubernetes
$character"""
```

## Disabling modules

```toml
# Disable specific modules
[python]
disabled = true

[ruby]
disabled = true

[nodejs]
disabled = true

[package]
disabled = true

# Disable all language detection
[battery]
disabled = true
```

## Nerd Font symbols

```toml
# Requires Nerd Font installed
[git_branch]
symbol = " "

[golang]
symbol = " "

[python]
symbol = " "

[rust]
symbol = " "

[nodejs]
symbol = " "

[docker_context]
symbol = " "

[kubernetes]
symbol = "󱃾 "
```

## ASCII-only (no icons)

```toml
[git_branch]
symbol = "git:"

[directory]
read_only = " ro"

[golang]
symbol = "go:"

[python]
symbol = "py:"
```

## Conditional display

```toml
# Only show in specific directories
[python]
detect_files = ["requirements.txt", "pyproject.toml", "setup.py"]

# Only show when files exist
[terraform]
detect_files = ["*.tf", "*.tfstate"]
detect_folders = [".terraform"]

# Show only in git repos
[git_branch]
only_attached = true
```

## Troubleshooting

### Check configuration

```bash
# Validate config
starship config

# Print current config location
starship config --print-config-path

# Explain current prompt
starship explain

# Test with specific shell
starship prompt --shell zsh
```

### Debug module

```bash
# See why module isn't showing
starship module git_branch

# Check timings
starship timings
```

### Common issues

**Symbols not displaying**: Install a Nerd Font and configure terminal to use it.

**Prompt slow**: Check `starship timings` for slow modules. Disable unused ones.

**Module not showing**: Check `detect_files` and `detect_folders` settings.

## Integration

### Zsh

```bash
# In .zshrc
eval "$(starship init zsh)"
```

### Bash

```bash
# In .bashrc
eval "$(starship init bash)"
```

### Fish

```fish
# In config.fish
starship init fish | source
```

## Example complete config

```toml
# ~/.config/starship.toml

add_newline = false

format = """
[┌─](bold green)$username$hostname$directory$git_branch$git_status$docker_context$kubernetes
[└─❯](bold green) """

[username]
show_always = false
style_user = "bold yellow"

[hostname]
ssh_only = true
format = "on [$hostname](bold red) "

[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold cyan"

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold red"
ahead = "⇡${count}"
behind = "⇣${count}"
modified = "!"
staged = "[++($count)](green)"
untracked = "?"

[docker_context]
symbol = " "
format = "via [$symbol$context]($style) "

[kubernetes]
symbol = "☸ "
format = 'on [$symbol$context( \($namespace\))]($style) '
disabled = false

# Disable language indicators
[python]
disabled = true

[ruby]
disabled = true

[nodejs]
disabled = true

[golang]
disabled = true

[rust]
disabled = true

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow) "
```

## Resources

When helping with Starship:
- Use `disabled = true` to hide modules
- Nerd Fonts required for fancy symbols
- Check `starship explain` for debugging
- Format string controls module order
- Each module has its own `[module]` section
- Reload with `exec $SHELL` or new terminal
