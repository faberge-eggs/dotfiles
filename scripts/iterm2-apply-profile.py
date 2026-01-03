#!/usr/bin/env python3
import plistlib
import os

# Read the preferences
plist_path = os.path.expanduser('~/Library/Preferences/com.googlecode.iterm2.plist')
with open(plist_path, 'rb') as f:
    prefs = plistlib.load(f)

# Get the default profile GUID
default_guid = prefs.get('Default Bookmark Guid', '')
print(f"Default GUID: {default_guid}")

# Find and update the default profile
profiles = prefs.get('New Bookmarks', [])
for profile in profiles:
    if profile.get('Guid') == default_guid:
        print(f"Found profile: {profile.get('Name')}")
        
        # Update colors
        profile['Background Color'] = {
            'Red Component': 0.118,
            'Green Component': 0.122,
            'Blue Component': 0.149
        }
        profile['Foreground Color'] = {
            'Red Component': 0.843,
            'Green Component': 0.855,
            'Blue Component': 0.878
        }
        
        # Update font
        profile['Normal Font'] = 'MesloLGS-NF-Regular 13'
        profile['Non Ascii Font'] = 'MesloLGS-NF-Regular 13'
        
        # Update window size
        profile['Columns'] = 120
        profile['Rows'] = 35
        
        # Update other settings
        profile['Transparency'] = 0.05
        profile['Blur'] = True
        profile['Blur Radius'] = 2.0
        profile['Scrollback Lines'] = 10000
        profile['Terminal Type'] = 'xterm-256color'
        profile['Silence Bell'] = True
        profile['Option Key Sends'] = 2
        profile['Right Option Key Sends'] = 2
        
        print("✓ Updated profile settings")
        break

# Write back
with open(plist_path, 'wb') as f:
    plistlib.dump(prefs, f)

print("✅ Profile applied successfully")
