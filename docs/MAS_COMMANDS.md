# MAS CLI Command Reference

Quick reference for `mas` (Mac App Store CLI) commands.

## Available Commands

### Check Configuration
```bash
mas config
# Output mas config & system info
```

### Search for Apps
```bash
mas search "App Name"

# Example
mas search "Amphetamine"
# Output: 937984704  Amphetamine
```

### Install Apps
```bash
# Install by ID
mas install 937984704

# Install multiple
mas install 937984704 425424353

# Get & install free app (same as install)
mas get 937984704
```

### List Installed Apps
```bash
mas list

# Example output:
# 937984704  Amphetamine (5.2.2)
# 425424353  The Unarchiver (4.3.0)
```

### Check for Updates
```bash
# List outdated apps
mas outdated

# Update all apps
mas upgrade

# Update specific app
mas upgrade 937984704
```

### App Information
```bash
# Get app info
mas info 937984704
mas lookup 937984704

# Example output shows:
# - Name
# - Price
# - Version
# - Bundle ID
# - etc.
```

### Open in App Store
```bash
# Open app page in App Store.app
mas open 937984704

# Open in web browser
mas home 937984704
```

### Uninstall
```bash
mas uninstall 937984704
```

### Sign Out
```bash
mas signout
# Signs out of Apple Account in App Store
```

### Other Commands
```bash
# Install first search result
mas lucky "App Name"

# Open app seller page
mas vendor 937984704
mas seller 937984704

# Reset App Store cache
mas reset

# Show version
mas version
mas --version
```

## Common Workflows

### Check if Signed In
```bash
mas list
# If you see apps: signed in
# If error/empty: not signed in
```

### Install from Brewfile
```bash
# 1. Sign into App Store (GUI)
open -a "App Store"

# 2. Verify
mas list

# 3. Install
brew bundle
```

### Search and Install
```bash
# 1. Search
mas search "Amphetamine"
# Output: 937984704  Amphetamine

# 2. Install
mas install 937984704

# 3. Verify
mas list | grep Amphetamine
```

### Update All Apps
```bash
# Check for updates
mas outdated

# Update all
mas upgrade

# Or update via Homebrew
brew bundle
```

## Command Comparison

| Old Command (deprecated) | New Command |
|--------------------------|-------------|
| `mas signin` | Use App Store GUI |
| `mas account` | `mas list` (to verify) |
| `mas purchase` | `mas get` or `mas install` |
| `mas update` | `mas upgrade` |

## Tips

1. **Sign-in**: No CLI sign-in available, must use GUI
2. **Verify sign-in**: Use `mas list` - if apps show, you're signed in
3. **Search before install**: Use `mas search` to find correct app ID
4. **Brewfile**: Keep MAS apps commented until signed in
5. **Updates**: `mas upgrade` updates all MAS apps at once

## Troubleshooting

### "Unexpected argument 'account'"
The `mas account` command was removed. Use `mas list` instead.

### "Unexpected argument 'signin'"
The `mas signin` command was removed. Sign in via App Store GUI.

### "No downloads initiated"
You're not signed into the App Store. Open App Store and sign in.

### App not installing
1. Verify app ID: `mas lookup <id>`
2. Check if already installed: `mas list`
3. Try opening in App Store: `mas open <id>`
