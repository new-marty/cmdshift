# Architecture

This document describes the three-layer design used to provide macOS-style keybindings on Linux via xremap.

## The evdev Pipeline

Understanding the key event pipeline is essential for reasoning about remapping:

```
Physical key press
  → evdev (kernel input event)
    → xremap modmap (modifier substitution)
      → xremap keymap (combo translation)
        → uinput (virtual input device)
          → XKB / libxkbcommon (layout interpretation)
            → Wayland compositor (GNOME Shell)
              → Application
```

Key points:
- xremap sits between the kernel and the compositor
- Modmap runs first, transforming individual key identities
- Keymap runs second, translating key combinations
- XKB options like `ctrl:nocaps` apply *after* xremap, at the compositor level
- This means CapsLock→Ctrl via XKB is fully compatible — xremap never sees CapsLock as Ctrl

## Layer 1: Modmap — Alt↔Super Swap

### What it does

Swaps the Alt and Super (Meta) keys at the physical level:

| Physical Key | After Modmap | macOS Mental Model |
|---|---|---|
| Left Alt | Left Super | Command (Cmd) |
| Right Alt | Right Super | Command (Cmd) |
| Left Super | Left Alt | Option |
| Right Super | Right Alt | Option |
| Ctrl | Ctrl (unchanged) | Control |

### Why this swap

On macOS, the Command key (physically next to spacebar, where Alt is on PC keyboards) is the primary modifier for shortcuts. By swapping Alt↔Super:

- Physical Alt (thumb position) becomes Super, which we treat as "Cmd" in keymap rules
- Physical Super (pinky position) becomes Alt, which we treat as "Option"
- Ctrl stays as Ctrl — no terminal breakage, no readline interference

### Why only one modmap

Toshy uses separate modmaps for GUI apps vs terminals because it virtualizes Cmd onto Right Ctrl. In our design, Ctrl is never remapped, so terminals work identically to GUI apps at the modmap level. One universal modmap is sufficient.

### xremap syntax

```yaml
modmap:
  - name: Alt-Super swap (Cmd/Option)
    remap:
      Alt_L: Super_L
      Alt_R: Super_R
      Super_L: Alt_L
      Super_R: Alt_R
```

## Layer 2: Keymap — Combo Translation

### Mental model after modmap

After the modmap, when writing keymap rules:
- `Super-` prefix = physical Alt key = macOS Cmd
- `Alt-` prefix = physical Super key = macOS Option
- `Ctrl-` prefix = physical Ctrl key = macOS Control

So `Super-c` in an xremap rule means "physical Alt+C" which the user thinks of as "Cmd+C".

### Block ordering and first-match-wins

xremap evaluates keymap blocks in order and uses the **first matching rule**. This means:
- Specific app overrides must come BEFORE general category rules
- General category rules must come BEFORE the catch-all General GUI block
- An app excluded from the General GUI (like remote desktop clients) won't get any GUI remaps

### Evaluation sequence

```
 1. Terminal per-app overrides      (Ghostty, Kitty, Konsole, etc.)
 2. General Terminals               (all apps in terminals list)
 3. Browser per-app overrides       (Firefox-specific, Chrome-specific)
 4. General Browsers                (all apps in browsers list)
 5. File Manager per-app overrides  (Nautilus, Dolphin, Thunar, etc.)
 6. General File Managers           (all apps in filemanagers list)
 7. Editor overrides                (VS Code, Sublime Text, JetBrains)
 8. Misc app overrides              (Thunderbird, LibreOffice, etc.)
 9. Cmd+Dot → Escape               (non-terminal apps only)
10. General GUI                     (catch-all, excludes remotes)
```

### `exact_match: false` (the default)

When `exact_match` is false (which is the default), xremap ignores extra modifiers not specified in the rule. This means:

- A rule `Super-c: Ctrl-c` will also match `Shift-Super-c` and produce `Shift-Ctrl-c`
- This gives us Cmd+Shift+C "for free" alongside Cmd+C — critical for selection variants of navigation shortcuts
- Set `exact_match: true` only when you need a rule to fire *exclusively* without extra modifiers

### Application filtering

xremap supports matching by WM_CLASS (application class):

```yaml
- name: General Terminals
  application:
    only:
      - /^alacritty$/
      - /^kitty$/
      - /^gnome-terminal$/
  remap:
    Super-c: Ctrl-Shift-c   # Copy in terminal
```

Use `only` for allow-lists, `not` for deny-lists. Values can be exact strings or `/regex/` patterns.

### How categories interact

A terminal like Alacritty might match:
1. **"Alacritty terminal"** per-app override (e.g., Cmd+K → Ctrl+L for clear)
2. **"General Terminals"** (Cmd+C → Ctrl+Shift+C, Cmd+V → Ctrl+Shift+V, etc.)

The General GUI block excludes only remotes (via `not:`), not terminals. Since xremap is first-match-wins **per combo**, a terminal app will:
- Match terminal-specific rules in the Terminals block (e.g., `Super-c → Ctrl-Shift-c`)
- Fall through to General GUI for combos NOT defined in the Terminals block (e.g., `Super-z → Ctrl-z`)

This is an important difference from Toshy, where keymaps are mutually exclusive. In xremap, a terminal app gets its copy/paste overrides from the Terminals block AND standard undo/redo from the General GUI block, because each combo is matched independently.

## Layer 3: GNOME gsettings

### The held-modifier problem

Some shortcuts require the modifier key to stay held while the user taps other keys. The canonical example is Alt-Tab app switching:

1. User presses and holds Alt (which is now Super after modmap)
2. User taps Tab repeatedly to cycle through windows
3. User releases Alt to select

xremap's keymap works on complete key combos (press + release). It can translate `Super-Tab` to `Alt-Tab` for a single press, but it cannot keep Alt held while the user continues tapping Tab. The held-modifier state gets lost in translation.

### What must be in gsettings

These shortcuts bypass xremap entirely and are configured directly in GNOME:

| Function | gsettings Value | Why |
|---|---|---|
| App switching (Cmd+Tab) | `<Super>Tab` | Held-modifier cycling |
| Reverse app switch | `<Shift><Super>Tab` | Held-modifier cycling |
| Window cycling (Cmd+`) | `<Super>Above_Tab` | Held-modifier cycling |
| Minimize (Cmd+H/M) | `<Super>h` / `<Super>m` | Held-modifier state |
| Maximize toggle | `<Ctrl><Super>f` | Could be keymap, but kept consistent |
| Lock screen | `<Ctrl><Super>q` | System-level action |
| Screenshots | Various | Platform-specific |

See [gnome-setup.md](gnome-setup.md) for the complete gsettings configuration.

### Why not put everything in gsettings?

gsettings shortcuts are limited:
- They can only trigger GNOME Shell actions, not arbitrary key output
- They don't support application-aware filtering
- They don't support key sequences (multi-step macros)
- They're GNOME-specific (not portable to KDE, Sway, etc.)

The keymap layer handles the vast majority of shortcuts. gsettings is only for the cases that fundamentally can't work through a keymap.

## Interaction with XKB

### CapsLock→Ctrl (`ctrl:nocaps`)

This XKB option remaps CapsLock to Ctrl at the compositor level. Since it runs *after* xremap in the pipeline:

- xremap never sees CapsLock events (they arrive as regular CapsLock from the kernel, but xremap doesn't need to handle them)
- Actually: XKB applies after uinput. When xremap outputs a Ctrl keycode, XKB doesn't interfere with it
- CapsLock physically pressed → kernel sends CapsLock → xremap passes it through → uinput → XKB converts to Ctrl → compositor sees Ctrl

This means `ctrl:nocaps` is fully compatible with our xremap config. No special handling needed.

### Setting it up

```bash
# Temporary (current session)
setxkbmap -option ctrl:nocaps

# Persistent (GNOME)
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
```
