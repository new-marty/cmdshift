# GNOME Setup

All GNOME gsettings changes needed alongside the xremap config. These handle shortcuts that require held-modifier state, which xremap's keymap layer cannot properly translate.

## Why These Are Needed

xremap's keymap translates discrete key combos: it sees `Super-Tab` pressed, emits `Alt-Tab`, done. But app switching requires the modifier to **stay held** while the user taps Tab repeatedly to cycle through windows. xremap can't maintain this held state through the translation — when it emits the `Alt-Tab` output, it releases the virtual Alt, breaking the cycling behavior.

The solution: bind these shortcuts directly in GNOME at the Super key level, so after our modmap swaps Alt→Super, the physical Alt (now Super) key directly triggers the GNOME action with proper held-modifier semantics.

## Required Settings

### Disable Super key overlay

The Super key normally opens GNOME Activities overview. Since physical Alt is now Super (our "Cmd" key), every Cmd combo would briefly flash the overview. Disable it:

```bash
gsettings set org.gnome.mutter overlay-key ''
```

### App switching (Cmd+Tab)

```bash
# Switch applications (Cmd+Tab)
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"

# Switch applications reverse (Cmd+Shift+Tab)
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
```

### Window cycling within app (Cmd+`)

`Above_Tab` is the key physically above Tab — the grave/backtick key. Using this name ensures it works regardless of keyboard layout.

```bash
# Switch windows of same app (Cmd+`)
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>Above_Tab']"

# Switch windows reverse (Cmd+Shift+`)
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Shift><Super>Above_Tab']"
```

### Minimize window (Cmd+H and Cmd+M)

On macOS, Cmd+H hides the current app and Cmd+M minimizes the window. Both map to minimize on Linux:

```bash
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h', '<Super>m']"
```

### Maximize toggle (Ctrl+Cmd+F)

On macOS, Ctrl+Cmd+F toggles full screen. Maps to maximize toggle on GNOME:

```bash
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Ctrl><Super>f']"
```

Note: After modmap, physical Ctrl stays Ctrl and physical Alt becomes Super, so physical Ctrl+Alt+F triggers `<Ctrl><Super>f`.

### Lock screen (Ctrl+Cmd+Q)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Ctrl><Super>q']"
```

### Screenshots

GNOME 42+ uses the Screenshot portal. These may need adjustment depending on your GNOME version:

```bash
# Full screenshot (Cmd+Shift+3)
gsettings set org.gnome.shell.keybindings screenshot "['<Shift>Print']"

# Window screenshot (Cmd+Shift+4)
gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt>Print']"

# Interactive screenshot (Cmd+Shift+5)
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['Print']"
```

Note: The screenshot shortcuts are also handled in the xremap keymap (Cmd+Shift+3/4/5 → Shift+Print / Alt+Print / Print). The xremap rules translate the key combo before it reaches GNOME, so the gsettings values here are what GNOME actually receives after xremap processing. These should already be the GNOME defaults.

### Disable conflicting default shortcuts

Some default GNOME shortcuts conflict with our remapping and should be cleared:

```bash
# Disable default Alt+Tab (we use Super+Tab now)
# This may not be needed if switch-applications above overrides it
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['']"
```

## Optional: Application launcher (Cmd+Space)

On macOS, Cmd+Space opens Spotlight. On GNOME, this can open the Activities overview or a launcher app:

```bash
# Option A: Use GNOME overview search (requires custom shortcut setup)
# The xremap keymap handles: Super-Space → Shift-Ctrl-Space (GNOME 45+)

# Option B: Disable if using a different launcher (ulauncher, rofi, etc.)
# Handle in xremap keymap with launch: action instead
```

## Verification

Check each setting was applied correctly:

```bash
gsettings get org.gnome.mutter overlay-key
# Expected: ''

gsettings get org.gnome.desktop.wm.keybindings switch-applications
# Expected: ['<Super>Tab']

gsettings get org.gnome.desktop.wm.keybindings switch-applications-backward
# Expected: ['<Shift><Super>Tab']

gsettings get org.gnome.desktop.wm.keybindings switch-group
# Expected: ['<Super>Above_Tab']

gsettings get org.gnome.desktop.wm.keybindings switch-group-backward
# Expected: ['<Shift><Super>Above_Tab']

gsettings get org.gnome.desktop.wm.keybindings minimize
# Expected: ['<Super>h', '<Super>m']

gsettings get org.gnome.desktop.wm.keybindings toggle-maximized
# Expected: ['<Ctrl><Super>f']

gsettings get org.gnome.settings-daemon.plugins.media-keys screensaver
# Expected: ['<Ctrl><Super>q']
```

## Revert to GNOME Defaults

If you need to undo all changes:

```bash
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
```

## Note on `setup-gnome.sh`

These settings will be codified in a `setup-gnome.sh` script when the config is implemented. The script will:
1. Apply all gsettings changes
2. Verify each setting
3. Optionally create a revert script
