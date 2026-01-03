#!/bin/bash
# Export iTerm2 preferences to dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ITERM2_CONFIG_DIR="$DOTFILES_DIR/config/iterm2"

echo "Exporting iTerm2 preferences..."

# Copy preferences file
if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
    cp ~/Library/Preferences/com.googlecode.iterm2.plist "$ITERM2_CONFIG_DIR/"
    echo "✓ Exported: com.googlecode.iterm2.plist"
else
    echo "✗ iTerm2 preferences not found"
    exit 1
fi

# Convert to JSON for easier viewing (optional)
if command -v plutil &>/dev/null; then
    plutil -convert json -o "$ITERM2_CONFIG_DIR/preferences.json" \
        "$ITERM2_CONFIG_DIR/com.googlecode.iterm2.plist"
    echo "✓ Converted: preferences.json"
fi

echo ""
echo "✅ iTerm2 preferences exported successfully!"
echo "Commit these changes to sync across machines."
