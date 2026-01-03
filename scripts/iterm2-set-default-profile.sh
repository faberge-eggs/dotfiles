#!/bin/bash
# Set the Dotfiles Default profile as the default iTerm2 profile

set -e

PROFILE_GUID="dotfiles-default-profile"

echo "Setting 'Dotfiles Default' as default profile..."

# Check if iTerm2 is running
if pgrep -x "iTerm2" > /dev/null; then
    echo "⚠️  Please quit iTerm2 first (⌘Q), then run this script again."
    exit 1
fi

# Set the default profile GUID
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$PROFILE_GUID"

echo "✅ Default profile set to 'Dotfiles Default'"
echo ""
echo "Launch iTerm2 to use the new default profile."
echo "All new windows and tabs will use this profile automatically."
