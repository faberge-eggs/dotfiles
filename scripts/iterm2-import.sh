#!/bin/bash
# Import iTerm2 preferences from dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ITERM2_CONFIG_DIR="$DOTFILES_DIR/config/iterm2"

echo "Importing iTerm2 preferences..."

# Check if iTerm2 is running
if pgrep -x "iTerm2" > /dev/null; then
    echo "⚠️  iTerm2 is running. Please quit iTerm2 first."
    echo "   Press Enter after quitting iTerm2..."
    read
fi

# Copy preferences file
if [ -f "$ITERM2_CONFIG_DIR/com.googlecode.iterm2.plist" ]; then
    cp "$ITERM2_CONFIG_DIR/com.googlecode.iterm2.plist" \
       ~/Library/Preferences/com.googlecode.iterm2.plist
    echo "✓ Imported: com.googlecode.iterm2.plist"
else
    echo "✗ Preferences file not found in $ITERM2_CONFIG_DIR"
    exit 1
fi

# Set custom preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM2_CONFIG_DIR"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo ""
echo "✅ iTerm2 preferences imported successfully!"
echo "Launch iTerm2 to use the new settings."
