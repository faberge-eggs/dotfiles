#!/bin/bash
# Import iTerm2 profile from iterm2-profile.json and set as default

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_JSON="$DOTFILES_DIR/config/iterm2/iterm2-profile.json"
PLIST_PATH="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

echo "Importing iTerm2 profile from JSON..."

# Check if profile JSON exists
if [ ! -f "$PROFILE_JSON" ]; then
    echo "✗ Profile not found: $PROFILE_JSON"
    exit 1
fi

# Check if iTerm2 is running
if pgrep -x "iTerm2" > /dev/null; then
    echo "⚠️  iTerm2 is running. Quitting iTerm2..."
    killall iTerm2 || true
    sleep 2
fi

# Use Python to import the profile
python3 - <<EOF
import plistlib
import json
import os
import sys

profile_json_path = "$PROFILE_JSON"
plist_path = "$PLIST_PATH"

# Read the profile JSON
print(f"Reading profile from: {profile_json_path}")
with open(profile_json_path, 'r') as f:
    new_profile = json.load(f)

# Read iTerm2 preferences (create if doesn't exist)
if os.path.exists(plist_path):
    with open(plist_path, 'rb') as f:
        prefs = plistlib.load(f)
else:
    print("Creating new preferences file...")
    prefs = {}

# Ensure New Bookmarks array exists
if 'New Bookmarks' not in prefs:
    prefs['New Bookmarks'] = []

# Check if profile with this GUID already exists
existing_index = None
profile_guid = new_profile.get('Guid')
for i, p in enumerate(prefs['New Bookmarks']):
    if p.get('Guid') == profile_guid:
        existing_index = i
        break

# Add or update the profile
if existing_index is not None:
    print(f"✓ Updating existing profile: {new_profile.get('Name', 'Unknown')}")
    prefs['New Bookmarks'][existing_index] = new_profile
else:
    print(f"✓ Adding new profile: {new_profile.get('Name', 'Unknown')}")
    prefs['New Bookmarks'].append(new_profile)

# Set as default profile
prefs['Default Bookmark Guid'] = profile_guid
print(f"✓ Set as default profile (GUID: {profile_guid})")

# Write back the preferences
with open(plist_path, 'wb') as f:
    plistlib.dump(prefs, f)

print("✓ Profile imported successfully")
EOF

echo ""
echo "✅ Profile imported and set as default!"
echo ""
echo "Next steps:"
echo "  1. Launch iTerm2: open -a iTerm"
echo "  2. The profile will be applied automatically"
echo ""
echo "To export your current profile after making changes:"
echo "  ./scripts/iterm2-export-profile.sh"
