#!/bin/bash
# Export current iTerm2 default profile to iterm2-profile.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_JSON="$DOTFILES_DIR/config/iterm2/iterm2-profile.json"
PLIST_PATH="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

echo "Exporting iTerm2 default profile to JSON..."

# Check if preferences exist
if [ ! -f "$PLIST_PATH" ]; then
    echo "✗ iTerm2 preferences not found: $PLIST_PATH"
    exit 1
fi

# Use Python to export the profile
python3 - <<EOF
import plistlib
import json
import sys

plist_path = "$PLIST_PATH"
profile_json_path = "$PROFILE_JSON"

# Read iTerm2 preferences
with open(plist_path, 'rb') as f:
    prefs = plistlib.load(f)

# Get the default profile GUID
default_guid = prefs.get('Default Bookmark Guid', '')
if not default_guid:
    print("✗ No default profile found")
    sys.exit(1)

print(f"Default profile GUID: {default_guid}")

# Find the default profile
profiles = prefs.get('New Bookmarks', [])
default_profile = None
for p in profiles:
    if p.get('Guid') == default_guid:
        default_profile = p
        break

if not default_profile:
    print("✗ Default profile not found in bookmarks")
    sys.exit(1)

profile_name = default_profile.get('Name', 'Unknown')
print(f"✓ Found profile: {profile_name}")

# Export to JSON
with open(profile_json_path, 'w') as f:
    json.dump(default_profile, f, indent=2, sort_keys=True)

print(f"✓ Exported to: {profile_json_path}")
EOF

echo ""
echo "✅ Profile exported successfully!"
echo ""
echo "The profile has been saved to:"
echo "  config/iterm2/iterm2-profile.json"
echo ""
echo "To apply this profile on another machine:"
echo "  ./scripts/iterm2-import-profile.sh"
