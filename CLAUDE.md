# Key Remapper — macOS-style keybindings on Linux via xremap

## Project Purpose

Comprehensive xremap configuration providing macOS-style keyboard shortcuts on Linux.
Uses [Toshy](https://github.com/RedBearAK/toshy) as the keybinding reference, translated
from Python/xwaykeyz to pure xremap YAML (Rust-based, no Python runtime).

## Target Environment

- **Desktop**: GNOME on Ubuntu, Wayland
- **Keyboard**: Standard PC (non-Apple) keyboard
- **Keymapper**: [xremap](https://github.com/xremap/xremap) with GNOME Wayland support
- **CapsLock→Ctrl**: Handled by XKB (`ctrl:nocaps`), compatible with xremap

## Architecture — Three Layers

### Layer 1: Modmap (Alt↔Super swap)
Physical Alt becomes Super (Cmd), physical Super becomes Alt (Option). Ctrl unchanged.
Only one universal modmap needed — no separate terminal modmap since Ctrl is unaffected.

### Layer 2: Keymap (~200 rules, ordered specific→general)
After modmap: `Super-` = Cmd, `Alt-` = Option, `Ctrl-` = Ctrl.
First-match-wins semantics. `exact_match: false` (default) auto-propagates Shift for selection variants.

**Block evaluation order:**
1. Terminal per-app overrides (Ghostty, Kitty, Konsole, etc.)
2. General Terminals
3. Browser per-app overrides (Firefox, Chrome)
4. General Browsers
5. File Manager per-app overrides
6. General File Managers
7. Editor overrides (VS Code, Sublime, JetBrains)
8. Misc app overrides
9. Cmd+Dot → Escape (non-terminal)
10. General GUI (catch-all, excludes only remotes)

### Layer 3: GNOME gsettings
Shortcuts requiring held-modifier state (Alt-Tab, window tiling, minimize) must be
rebound at GNOME level — xremap keymap can't handle press-release behavior for these.

## Config File

`config.yml` — xremap YAML format. Not yet created.

## Critical Design Decisions

- **App switching** (Cmd+Tab) → GNOME gsettings, NOT xremap keymap (held-modifier issue)
- **`exact_match: false`** (default) auto-propagates Shift for selection variants
- **General GUI keymap** applies to ALL apps; terminal/browser/editor blocks override specific combos
- **CapsLock→Ctrl** stays in XKB (`ctrl:nocaps`), compatible with xremap
- **Enter-to-Rename** (Toshy's iEF2) simplified to `Enter: F2` in file managers (no state machine)

## Key References

- [Toshy config](https://github.com/RedBearAK/toshy/blob/main/default-toshy-config/toshy_config.py) — keybinding reference source
- [xremap repo](https://github.com/xremap/xremap) — keymapper documentation
- `docs/` folder — architecture, keybinding tables, app lists, syntax guide

## How to Add a New App Override

Create a keymap block with `application: { only: [...] }` **BEFORE** the general block
for that category. xremap uses first-match-wins, so specific rules must precede general ones.

## Debug Commands

```bash
# Run with debug logging
RUST_LOG=debug xremap config.yml

# Discover WM_CLASS on GNOME Wayland
busctl --user call org.gnome.Shell /de/lucaswerkmeister/ActivateWindowByTitle \
  de.lucaswerkmeister.ActivateWindowByTitle Activate s ""
# Or use xprop (X11) / xdotool
# Or: gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell \
#   --method org.gnome.Shell.Eval "global.get_window_actors().map(a=>a.meta_window.get_wm_class())"
```
