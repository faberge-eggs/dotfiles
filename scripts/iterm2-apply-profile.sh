#!/bin/bash
# Apply iTerm2 dynamic profile from dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ITERM2_CONFIG_DIR="$DOTFILES_DIR/config/iterm2"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

echo "Applying iTerm2 profile..."

# Create dynamic profiles directory if it doesn't exist
mkdir -p "$DYNAMIC_PROFILES_DIR"

# Copy the dynamic profile
if [ -f "$ITERM2_CONFIG_DIR/dotfiles-profile.json" ]; then
    cp "$ITERM2_CONFIG_DIR/dotfiles-profile.json" "$DYNAMIC_PROFILES_DIR/"
    echo "✓ Copied: dotfiles-profile.json"
else
    echo "✗ Profile file not found in $ITERM2_CONFIG_DIR"
    exit 1
fi

# Check if iTerm2 is running
if pgrep -x "iTerm2" > /dev/null; then
    echo ""
    echo "⚠️  iTerm2 is running. The profile is now available."
    echo "   To use it:"
    echo "   1. Open iTerm2 Preferences (⌘,)"
    echo "   2. Go to Profiles"
    echo "   3. Select 'Dotfiles Default' from the list"
    echo "   4. Click 'Other Actions...' > 'Set as Default'"
    echo ""
    echo "   Or create a new window with this profile:"
    echo "   Profiles > Dotfiles Default > New Window"
else
    echo ""
    echo "✅ Profile installed successfully!"
    echo "Launch iTerm2 and select 'Dotfiles Default' profile."
fi
