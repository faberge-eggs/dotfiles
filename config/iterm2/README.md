# iTerm2 Configuration

This directory stores iTerm2 preferences for syncing across machines.

## How It Works

iTerm2 can load preferences from a custom directory instead of using the default location. This allows you to version control your iTerm2 settings.

## Setup

### Option 1: Automatic (via Ansible)

Run the Ansible playbook which will configure iTerm2 automatically:

```bash
ansible-playbook playbook.yml
```

### Option 2: Manual Setup

1. **Save current preferences to this directory:**
   ```bash
   # Set custom preferences directory
   defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.dotfiles/config/iterm2"

   # Tell iTerm2 to load preferences from custom directory
   defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
   ```

2. **Restart iTerm2** for changes to take effect

3. **Make changes in iTerm2** and they will auto-save to `config/iterm2/`

## Loading Configuration on New Machine

When you clone this dotfiles repo on a new machine:

1. Run bootstrap or Ansible playbook (automatic)
   ```bash
   ./bootstrap.sh
   ```

OR manually:

2. Set the preferences location:
   ```bash
   defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.dotfiles/config/iterm2"
   defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
   ```

3. Restart iTerm2

4. Your saved preferences will be loaded automatically

## What Gets Saved

- Color schemes
- Key bindings
- Profiles (shell settings, colors, fonts)
- Window arrangements
- Status bar configuration
- All other iTerm2 preferences

## Files

- `com.googlecode.iterm2.plist` - Full iTerm2 preferences (binary plist, auto-saved by iTerm2)
- `preferences.json` - Human-readable JSON version for review and diffs
- `iterm_profile.json` - Reference profile configuration (colors, fonts, window settings)

## Scripts

### Export Current Settings
```bash
./scripts/iterm2-export.sh
```
Exports your current iTerm2 settings. Run after making changes in iTerm2.

### Import Settings
```bash
./scripts/iterm2-import.sh
```
Imports full preferences from this directory. Use on new machines.

### Apply Profile
```bash
python3 scripts/iterm2-apply-profile.py
```
Applies custom profile settings (colors, fonts, etc.) to your default profile.
Quit iTerm2 first, then run this script.

## Tips

- **Commit changes**: After making iTerm2 config changes, commit the updated plist file
- **Profile-specific settings**: You can create different profiles for work/personal
- **Sync frequency**: iTerm2 saves preferences automatically, but you control when to commit/push

## Troubleshooting

### Preferences not loading

1. Check the preference is set:
   ```bash
   defaults read com.googlecode.iterm2 PrefsCustomFolder
   defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder
   ```

2. Make sure iTerm2 is completely quit (⌘Q)

3. Restart iTerm2

### Conflicts between machines

If you get conflicts when syncing:
1. Choose which machine's settings you want to keep
2. Restart iTerm2 on both machines
3. The last-saved settings will take effect
