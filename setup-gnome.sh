#!/usr/bin/env bash
# setup-gnome.sh — Layer 3: GNOME gsettings for macOS-style keybindings
#
# Idempotent — safe to run multiple times. Applies settings that require
# held-modifier state (app switching, minimize, etc.) which xremap's keymap
# layer cannot handle.
#
# Usage: ./setup-gnome.sh
# Revert: ./setup-gnome.sh --revert

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ok()   { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$1"; }
fail() { printf "${RED}✗${NC} %s\n" "$1"; }

# --- Revert mode ---
if [[ "${1:-}" == "--revert" ]]; then
    echo "Reverting all gsettings to GNOME defaults..."
    gsettings reset org.gnome.mutter overlay-key
    gsettings reset org.gnome.desktop.wm.keybindings switch-applications
    gsettings reset org.gnome.desktop.wm.keybindings switch-applications-backward
    gsettings reset org.gnome.desktop.wm.keybindings switch-group
    gsettings reset org.gnome.desktop.wm.keybindings switch-group-backward
    gsettings reset org.gnome.desktop.wm.keybindings minimize
    gsettings reset org.gnome.desktop.wm.keybindings toggle-maximized
    gsettings reset org.gnome.settings-daemon.plugins.media-keys screensaver
    gsettings reset org.gnome.desktop.wm.keybindings switch-windows
    gsettings reset org.gnome.desktop.wm.keybindings switch-windows-backward
    gsettings reset org.gnome.desktop.input-sources xkb-options
    ok "All settings reverted to GNOME defaults"
    exit 0
fi

echo "Applying GNOME gsettings for macOS-style keybindings..."
echo ""

# --- Helper: set and verify ---
apply() {
    local schema="$1" key="$2" value="$3" expected="$4"
    gsettings set "$schema" "$key" "$value"
    local actual
    actual=$(gsettings get "$schema" "$key")
    if [[ "$actual" == "$expected" ]]; then
        ok "$schema $key = $actual"
    else
        fail "$schema $key: expected $expected, got $actual"
    fi
}

# --- Disable Super key overlay ---
# Prevents Activities overview flash on every Cmd combo
apply org.gnome.mutter overlay-key "''" "''"

# --- App switching (Cmd+Tab) ---
apply org.gnome.desktop.wm.keybindings switch-applications \
    "['<Super>Tab']" "['<Super>Tab']"
apply org.gnome.desktop.wm.keybindings switch-applications-backward \
    "['<Shift><Super>Tab']" "['<Shift><Super>Tab']"

# --- Window cycling within app (Cmd+`) ---
apply org.gnome.desktop.wm.keybindings switch-group \
    "['<Super>Above_Tab']" "['<Super>Above_Tab']"
apply org.gnome.desktop.wm.keybindings switch-group-backward \
    "['<Shift><Super>Above_Tab']" "['<Shift><Super>Above_Tab']"

# --- Minimize (Cmd+H and Cmd+M) ---
apply org.gnome.desktop.wm.keybindings minimize \
    "['<Super>h', '<Super>m']" "['<Super>h', '<Super>m']"

# --- Maximize toggle (Ctrl+Cmd+F) ---
apply org.gnome.desktop.wm.keybindings toggle-maximized \
    "['<Ctrl><Super>f']" "['<Ctrl><Super>f']"

# --- Lock screen (Ctrl+Cmd+Q) ---
apply org.gnome.settings-daemon.plugins.media-keys screensaver \
    "['<Ctrl><Super>q']" "['<Ctrl><Super>q']"

# --- Clear conflicting defaults ---
apply org.gnome.desktop.wm.keybindings switch-windows \
    "['']" "['']"
apply org.gnome.desktop.wm.keybindings switch-windows-backward \
    "['']" "['']"

# --- CapsLock → Ctrl via XKB ---
# Check current xkb-options and add ctrl:nocaps if not present
current_xkb=$(gsettings get org.gnome.desktop.input-sources xkb-options)
if echo "$current_xkb" | grep -q "ctrl:nocaps"; then
    ok "CapsLock→Ctrl already set in XKB options"
else
    if [[ "$current_xkb" == "@as []" ]]; then
        apply org.gnome.desktop.input-sources xkb-options \
            "['ctrl:nocaps']" "['ctrl:nocaps']"
    else
        # Append to existing options
        new_xkb=$(echo "$current_xkb" | sed "s/]$/, 'ctrl:nocaps']/")
        gsettings set org.gnome.desktop.input-sources xkb-options "$new_xkb"
        ok "Added ctrl:nocaps to existing XKB options"
    fi
fi

echo ""
ok "All GNOME settings applied successfully"
echo ""
echo "Note: App switching (Cmd+Tab) and window cycling (Cmd+\`) are handled"
echo "by GNOME directly, not xremap. These require held-modifier state."
