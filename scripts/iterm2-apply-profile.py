#!/usr/bin/env python3
"""
Apply iTerm2 profile from iterm_profile.json to the default profile.
"""
import plistlib
import json
import os
import sys

# Paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DOTFILES_DIR = os.path.dirname(SCRIPT_DIR)
PROFILE_JSON = os.path.join(DOTFILES_DIR, 'config/iterm2/iterm_profile.json')
PLIST_PATH = os.path.expanduser('~/Library/Preferences/com.googlecode.iterm2.plist')

def color_to_plist(color_dict):
    """Convert JSON color format to iTerm2 plist format."""
    return {
        'Red Component': color_dict['Red'],
        'Green Component': color_dict['Green'],
        'Blue Component': color_dict['Blue'],
        'Color Space': 'sRGB',
        'Alpha Component': 1.0
    }

def apply_profile():
    """Read profile JSON and apply to default iTerm2 profile."""
    
    # Check if profile JSON exists
    if not os.path.exists(PROFILE_JSON):
        print(f"✗ Profile not found: {PROFILE_JSON}")
        return False
    
    # Read the profile JSON
    print(f"Reading profile from: {PROFILE_JSON}")
    with open(PROFILE_JSON, 'r') as f:
        profile = json.load(f)
    
    # Read iTerm2 preferences
    if not os.path.exists(PLIST_PATH):
        print(f"✗ iTerm2 preferences not found: {PLIST_PATH}")
        return False
    
    with open(PLIST_PATH, 'rb') as f:
        prefs = plistlib.load(f)
    
    # Get the default profile GUID
    default_guid = prefs.get('Default Bookmark Guid', '')
    if not default_guid:
        print("✗ No default profile found")
        return False
    
    print(f"Default profile GUID: {default_guid}")
    
    # Find and update the default profile
    profiles = prefs.get('New Bookmarks', [])
    profile_found = False
    
    for p in profiles:
        if p.get('Guid') == default_guid:
            profile_found = True
            profile_name = p.get('Name', 'Default')
            print(f"✓ Found profile: {profile_name}")
            
            # Apply colors
            if 'Colors' in profile:
                print("  Applying colors...")
                colors = profile['Colors']
                for i in range(16):
                    key = f"Ansi {i} Color"
                    if key in colors:
                        p[key] = color_to_plist(colors[key])
                
                if 'Background Color' in colors:
                    p['Background Color'] = color_to_plist(colors['Background Color'])
                if 'Foreground Color' in colors:
                    p['Foreground Color'] = color_to_plist(colors['Foreground Color'])
                if 'Cursor Color' in colors:
                    p['Cursor Color'] = color_to_plist(colors['Cursor Color'])
                if 'Cursor Text Color' in colors:
                    p['Cursor Text Color'] = color_to_plist(colors['Cursor Text Color'])
            
            # Apply font settings
            if 'Font' in profile:
                print("  Applying fonts...")
                font = profile['Font']
                if 'Normal Font' in font:
                    p['Normal Font'] = font['Normal Font']
                if 'Non Ascii Font' in font:
                    p['Non Ascii Font'] = font['Non Ascii Font']
                if 'Use Non-ASCII Font' in font:
                    p['Use Non-ASCII Font'] = font['Use Non-ASCII Font']
                if 'Horizontal Spacing' in font:
                    p['Horizontal Spacing'] = font['Horizontal Spacing']
                if 'Vertical Spacing' in font:
                    p['Vertical Spacing'] = font['Vertical Spacing']
                if 'Use Bold Font' in font:
                    p['Use Bold Font'] = font['Use Bold Font']
                if 'Use Italic Font' in font:
                    p['Use Italic Font'] = font['Use Italic Font']
                if 'ASCII Anti Aliased' in font:
                    p['ASCII Anti Aliased'] = font['ASCII Anti Aliased']
            
            # Apply window settings
            if 'Window' in profile:
                print("  Applying window settings...")
                window = profile['Window']
                if 'Transparency' in window:
                    p['Transparency'] = window['Transparency']
                if 'Blur' in window:
                    p['Blur'] = window['Blur']
                if 'Blur Radius' in window:
                    p['Blur Radius'] = window['Blur Radius']
                if 'Columns' in window:
                    p['Columns'] = window['Columns']
                if 'Rows' in window:
                    p['Rows'] = window['Rows']
            
            # Apply terminal settings
            if 'Terminal' in profile:
                print("  Applying terminal settings...")
                terminal = profile['Terminal']
                if 'Scrollback Lines' in terminal:
                    p['Scrollback Lines'] = terminal['Scrollback Lines']
                if 'Unlimited Scrollback' in terminal:
                    p['Unlimited Scrollback'] = terminal['Unlimited Scrollback']
                if 'Terminal Type' in terminal:
                    p['Terminal Type'] = terminal['Terminal Type']
                if 'Silence Bell' in terminal:
                    p['Silence Bell'] = terminal['Silence Bell']
                if 'Visual Bell' in terminal:
                    p['Visual Bell'] = terminal['Visual Bell']
            
            # Apply cursor settings
            if 'Cursor' in profile:
                print("  Applying cursor settings...")
                cursor = profile['Cursor']
                if 'Cursor Type' in cursor:
                    p['Cursor Type'] = cursor['Cursor Type']
                if 'Blinking Cursor' in cursor:
                    p['Blinking Cursor'] = cursor['Blinking Cursor']
            
            # Apply keyboard settings
            if 'Keyboard' in profile:
                print("  Applying keyboard settings...")
                keyboard = profile['Keyboard']
                if 'Option Key Sends' in keyboard:
                    p['Option Key Sends'] = keyboard['Option Key Sends']
                if 'Right Option Key Sends' in keyboard:
                    p['Right Option Key Sends'] = keyboard['Right Option Key Sends']
            
            # Apply session settings
            if 'Session' in profile:
                print("  Applying session settings...")
                session = profile['Session']
                if 'Close Sessions On End' in session:
                    p['Close Sessions On End'] = session['Close Sessions On End']
                if 'Prompt Before Closing 2' in session:
                    p['Prompt Before Closing 2'] = session['Prompt Before Closing 2']
            
            break
    
    if not profile_found:
        print("✗ Default profile not found in preferences")
        return False
    
    # Write back the preferences
    print("  Writing preferences...")
    with open(PLIST_PATH, 'wb') as f:
        plistlib.dump(prefs, f)
    
    print("\n✅ Profile applied successfully!")
    print("\nNext steps:")
    print("  1. Restart iTerm2: killall iTerm2 && open -a iTerm")
    print("  2. Or use: Preferences > Profiles > Other Actions > Reload")
    
    return True

if __name__ == '__main__':
    success = apply_profile()
    sys.exit(0 if success else 1)
