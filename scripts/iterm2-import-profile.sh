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
    source_profile = json.load(f)

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

# Get the current default profile GUID
default_guid = prefs.get('Default Bookmark Guid')

# Find the default profile
target_profile = None
for p in prefs['New Bookmarks']:
    if p.get('Guid') == default_guid:
        target_profile = p
        break

# If no default profile exists, use the source profile as-is
if target_profile is None:
    print(f"✓ Adding new profile: {source_profile.get('Name', 'Default')}")
    prefs['New Bookmarks'].append(source_profile)
    prefs['Default Bookmark Guid'] = source_profile.get('Guid')
    print(f"✓ Set as default profile (GUID: {source_profile.get('Guid')})")
else:
    # Update the existing default profile with settings from source
    # Keep the existing GUID but update all other settings
    existing_guid = target_profile.get('Guid')
    existing_name = target_profile.get('Name', 'Default')
    print(f"✓ Updating existing profile: {existing_name} (GUID: {existing_guid})")

    # Copy all settings from source to target, but keep the original GUID
    for key, value in source_profile.items():
        if key != 'Guid':  # Don't overwrite the GUID
            target_profile[key] = value

    print(f"✓ Profile settings applied")

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
