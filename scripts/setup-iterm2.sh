#!/bin/bash

# Setup iTerm2 to use custom preferences directory
# This allows iTerm2 preferences to be version controlled

set -e

DOTFILES_DIR="${HOME}/.dotfiles"
ITERM2_PREFS_DIR="${DOTFILES_DIR}/config/iterm2"

echo "Setting up iTerm2 configuration..."

# Check if iTerm2 is installed
if [ ! -d "/Applications/iTerm.app" ]; then
    echo "⚠️  iTerm2 is not installed. Install it first with: brew install --cask iterm2"
    exit 1
fi

# Create config directory if it doesn't exist
mkdir -p "${ITERM2_PREFS_DIR}"

# Set custom preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${ITERM2_PREFS_DIR}"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "✅ iTerm2 configured to use: ${ITERM2_PREFS_DIR}"
echo ""
echo "Next steps:"
echo "  1. Restart iTerm2 (⌘Q to quit, then reopen)"
echo "  2. Make any preference changes you want"
echo "  3. Changes will auto-save to config/iterm2/"
echo "  4. Commit the changes: git add config/iterm2/ && git commit -m 'Update iTerm2 config'"
echo ""
echo "To verify configuration:"
echo "  defaults read com.googlecode.iterm2 PrefsCustomFolder"
echo "  defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder"
