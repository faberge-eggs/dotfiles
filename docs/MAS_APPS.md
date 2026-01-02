# Mac App Store Apps (MAS)

This guide explains how to install Mac App Store apps via Homebrew.

## Prerequisites

### 1. Sign into Mac App Store

Before using `mas`, you must be signed into the Mac App Store:

**Important:** The `mas signin` and `mas account` commands have been removed. You must sign in via the GUI.

```bash
# Open Mac App Store
open -a "App Store"

# Sign in through the GUI (Store menu → Sign In)

# Verify you're signed in (if you see apps listed, you're signed in)
mas list
```

### 2. Install mas CLI

Already included in Brewfile:
```bash
brew install mas
```

## Available Apps

The following Mac App Store apps are available in the Brewfile (currently commented out):

```ruby
mas "Xcode", id: 497799835                    # Apple's IDE
mas "1Password for Safari", id: 1569813296    # Password manager extension
mas "The Unarchiver", id: 425424353           # Archive utility
mas "Amphetamine", id: 937984704              # Keep Mac awake utility
```

## How to Enable

### Option 1: Uncomment in Brewfile

1. Edit `Brewfile`:
   ```bash
   vim Brewfile
   ```

2. Uncomment the apps you want:
   ```ruby
   # Before
   # mas "Amphetamine", id: 937984704

   # After
   mas "Amphetamine", id: 937984704
   ```

3. Install:
   ```bash
   brew bundle
   ```

### Option 2: Install Manually

```bash
# Install individual app
mas install 937984704  # Amphetamine

# Or by name (if you know it)
mas install Amphetamine
```

## Finding App IDs

### Method 1: Search via mas
```bash
mas search "App Name"
```

Example:
```bash
$ mas search "1Password"
1569813296  1Password for Safari
```

### Method 2: From Mac App Store URL
The App Store URL contains the ID:
```
https://apps.apple.com/us/app/amphetamine/id937984704
                                             ^^^^^^^^^^
                                             This is the ID
```

## Common Apps

Here are some popular Mac App Store apps:

```ruby
# Productivity
mas "Things 3", id: 904280696
mas "Bear", id: 1091189122
mas "Magnet", id: 441258766
mas "Amphetamine", id: 937984704

# Development
mas "Xcode", id: 497799835
mas "Patterns", id: 429449079

# Utilities
mas "The Unarchiver", id: 425424353
mas "Keka", id: 470158793
mas "Battery Indicator", id: 1206020918

# Media
mas "GarageBand", id: 682658836
mas "iMovie", id: 408981434

# Extensions
mas "1Password for Safari", id: 1569813296
mas "Save to Pocket", id: 1477385213
```

## Troubleshooting

### Error: "No downloads initiated for ADAM ID"

**Cause:** Not signed into Mac App Store, or app not available in your region.

**Solution:**
1. Sign into Mac App Store (GUI only):
   ```bash
   # Open Mac App Store
   open -a "App Store"
   ```
   Then sign in via: **Store menu → Sign In**

2. Verify you're signed in:
   ```bash
   mas list
   # If you see apps listed, you're signed in
   # If empty or error, you're not signed in
   ```

3. Try again:
   ```bash
   brew bundle
   ```

### Error: "The app could not be found"

**Cause:** Invalid app ID or app removed from store.

**Solution:**
1. Search for the app:
   ```bash
   mas search "App Name"
   ```

2. Verify the ID is correct

3. Update Brewfile with correct ID

### Error: "Sign in required"

**Cause:** Not authenticated with Mac App Store.

**Solution:**
```bash
# Open Mac App Store
open -a "App Store"

# Sign in through the GUI:
# Store menu → Sign In

# Verify sign-in
mas list  # Should show installed apps
```

### Already Purchased Apps

If you've already purchased/downloaded an app:

```bash
# List installed MAS apps
mas list

# Upgrade all MAS apps
mas upgrade
```

## Best Practices

1. **Comment out by default** - MAS apps require manual sign-in, so keep them commented in Brewfile
2. **Document IDs** - Add comments with app names next to IDs
3. **Region-specific** - Some apps may not be available in all regions
4. **Updates** - MAS apps update through Mac App Store, not Homebrew
5. **Backup list** - Keep list of your purchased apps for reference

## Adding MAS Apps to Your Setup

### For Own Machine (Personal)

Add to `Brewfile.own`:
```ruby
# Personal Mac App Store apps
mas "Things 3", id: 904280696
mas "Bear", id: 1091189122
```

### For Workato Machine

Add to `Brewfile.workato`:
```ruby
# Work Mac App Store apps
mas "Xcode", id: 497799835
mas "Slack", id: 803453959
```

## Verification

Check if MAS apps are installed:
```bash
# List all installed MAS apps
mas list

# Check specific app
mas list | grep Amphetamine

# Check outdated apps
mas outdated
```

## Automated Installation

To automate MAS app installation:

1. **Sign into Mac App Store** (one-time, manual, GUI only):
   ```bash
   open -a "App Store"
   # Store menu → Sign In
   ```

2. **Verify sign-in**:
   ```bash
   mas list  # Shows installed MAS apps if signed in
   ```

3. Uncomment desired apps in Brewfile

4. Run:
   ```bash
   brew bundle
   ```

**Note:** CLI sign-in (`mas signin`) was removed in mas 1.8.0. You must use the Mac App Store GUI.
