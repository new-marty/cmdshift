# xremap Configuration Guide

YAML syntax reference for [xremap](https://github.com/xremap/xremap), tailored to this project's macOS-style keybinding config.

## Config File Structure

A config file has these top-level sections:

```yaml
# Optional: reusable YAML anchors
shared:
  terminals: &terminals
    - alacritty
    - kitty

# Optional: global settings
keypress_delay_ms: 0    # delay between synthesized key events (default: 0)
throttle_ms: 0          # global slowdown for all synthetic events (default: 0)

# Optional: promote keys to modifier status
virtual_modifiers:
  - CapsLock

# Optional: modal remapping
default_mode: default

# Layer 1: individual key remapping
modmap:
  - name: My Modmap
    remap:
      Alt_L: Super_L

# Layer 2: combo translation
keymap:
  - name: My Keymap
    remap:
      Super-c: Ctrl-c
```

## Modmap Syntax

Modmap remaps individual keys (not combos). It runs before keymap.

### Simple remap

```yaml
modmap:
  - name: Alt-Super swap
    remap:
      Alt_L: Super_L
      Alt_R: Super_R
      Super_L: Alt_L
      Super_R: Alt_R
```

### Multi-purpose key (held vs alone)

```yaml
modmap:
  - name: Space as Shift when held
    remap:
      Space:
        held: Shift_L
        alone: Space
        alone_timeout_millis: 1000  # default: 1000ms
```

With `free_hold: true`, the `held` action only triggers when another key is pressed while the multi-purpose key is held down (not just from holding it alone past the timeout).

### Disable a key

```yaml
modmap:
  - remap:
      CapsLock: []    # disabled, produces nothing
```

### One key to multiple simultaneous keys

```yaml
modmap:
  - remap:
      KEY_A: [KEY_B, KEY_C]    # pressing A produces B+C simultaneously
```

### Device filtering

```yaml
modmap:
  - name: Apple keyboard modmap
    device:
      only:
        - 'Apple Internal Keyboard'
    remap:
      Alt_L: Super_L
```

### Application filtering

```yaml
modmap:
  - name: Terminal-only modmap
    application:
      only:
        - /^alacritty$/
    remap:
      CapsLock: Ctrl_L
```

## Keymap Syntax

Keymap translates key combinations. Multiple keymap blocks are evaluated in order (first match wins per combo).

### Combo → Combo

```yaml
keymap:
  - name: Standard shortcuts
    remap:
      Super-c: Ctrl-c       # Cmd+C → Ctrl+C
      Super-q: Alt-F4       # Cmd+Q → Alt+F4
```

### Combo → Key Sequence

```yaml
keymap:
  - remap:
      Super-Backspace: [Shift-Home, Backspace]   # Delete line left of cursor
      Alt-Delete: [Escape, d]                     # readline: delete word right
```

### Combo → Launch Command

```yaml
keymap:
  - remap:
      Super-Space:
        launch: ["rofi", "-show", "drun"]
```

### Nested Sequences (Emacs-style prefix keys)

```yaml
keymap:
  - remap:
      Ctrl-x:
        remap:
          Ctrl-c: Ctrl-q        # Ctrl+X, Ctrl+C → Ctrl+Q
          Ctrl-s: Ctrl-s        # Ctrl+X, Ctrl+S → Ctrl+S
        timeout_millis: 200     # how long to wait for second key
        timeout_key: Ctrl-x     # fallback if timeout expires
```

### Mark mode (Emacs-style selection)

```yaml
keymap:
  - remap:
      Ctrl-Space: { set_mark: true }
      Ctrl-f: { with_mark: Right }      # moves right, or Shift+Right if mark set
      Ctrl-g: { set_mark: false }        # cancel mark
```

### Escape next key

```yaml
keymap:
  - remap:
      Ctrl-q: { escape_next_key: true }  # next keypress bypasses all keymaps
```

## Key Naming

Key names come from Linux evdev scancodes. The `KEY_` prefix is optional, and names are case-insensitive:

```yaml
# These are all equivalent:
KEY_CAPSLOCK
CAPSLOCK
CapsLock
capslock
```

### Modifier Prefixes

| Modifier | Prefixes (any of) |
|---|---|
| Shift | `Shift-` |
| Control | `C-`, `Ctrl-`, `Control-` |
| Alt | `M-`, `Alt-` |
| Super/Win | `Super-`, `Win-`, `Windows-` |

Combine multiple modifiers: `C-Shift-a`, `Super-Alt-Up`

Side-specific modifiers: `Ctrl_L-a`, `Shift_R-b`

### Common Key Names

| Key | Names |
|---|---|
| Letters | `a`..`z` (case-insensitive) |
| Numbers | `KEY_1`..`KEY_0`, or just `1`..`0` |
| F-keys | `F1`..`F24` |
| Arrows | `Left`, `Right`, `Up`, `Down` |
| Navigation | `Home`, `End`, `Page_Up`, `Page_Down` |
| Editing | `Backspace`, `Delete`, `Insert`, `Enter`, `Tab`, `Escape` |
| Punctuation | `Minus`, `Equal`, `Left_Brace`, `Right_Brace`, `Semicolon`, `Apostrophe`, `Grave`, `Comma`, `Dot`, `Slash`, `Backslash` |
| Modifiers | `Shift_L`, `Shift_R`, `Ctrl_L`, `Ctrl_R`, `Alt_L`, `Alt_R`, `Super_L`, `Super_R` |
| Numpad | `KP0`..`KP9`, `KPPLUS`, `KPMINUS`, `KPASTERISK`, `KPSLASH`, `KPDOT`, `KPENTER` |
| Media | `Mute`, `VolumeDown`, `VolumeUp`, `PlayPause`, `StopCD`, `NextSong`, `PreviousSong` |
| Special | `Print` (PrintScreen), `ScrollLock`, `Pause`, `Numlock` |

## Application Matching

Filter keymap blocks to specific applications using WM_CLASS.

### Allow list

```yaml
keymap:
  - name: Terminal shortcuts
    application:
      only:
        - alacritty              # exact string match (case-insensitive)
        - /^gnome-terminal/      # regex pattern
        - /^org\.kde\.konsole$/  # regex with escaped dots
    remap:
      Super-c: Ctrl-Shift-c
```

### Deny list

```yaml
keymap:
  - name: General GUI
    application:
      not:
        - /^anydesk$/i
        - /^virtualbox/i
        - /^remmina$/i
    remap:
      Super-c: Ctrl-c
```

If both `only` and `not` are specified, `only` takes precedence.

### Matching behavior

- Plain strings are matched case-insensitively against the full WM_CLASS
- Regex patterns are delimited by `/` and support standard regex syntax
- On GNOME Wayland, WM_CLASS is obtained via the xremap GNOME Shell extension

## Window Title Matching

Filter by window title in addition to (or instead of) application class:

```yaml
keymap:
  - name: Nautilus Properties dialog
    application:
      only: [/^nautilus$/]
    window:
      only: [/Properties$/]
    remap:
      Enter: Enter    # don't remap Enter in properties dialogs
```

## Device Matching

Filter modmap or keymap to specific input devices:

```yaml
modmap:
  - name: External keyboard only
    device:
      only:
        - 'Keychron K2'                  # device name (or substring)
        - /dev/input/event5              # device path
        - event5                         # filename
        - ids:0x3f0:0x24                 # vendor:product ID (hex)
    remap:
      Alt_L: Super_L
```

Note: Device matching does NOT support regex patterns (unlike application matching). Use exact names or substrings.

## `exact_match`

Controls whether extra modifiers are passed through.

### `exact_match: false` (default)

A rule `Super-c: Ctrl-c` will also match `Shift-Super-c` → `Shift-Ctrl-c`. This is extremely useful because it gives us selection variants for free:

- `Super-Left: Home` also handles `Shift-Super-Left: Shift-Home` (select to beginning of line)
- `Alt-Right: Ctrl-Right` also handles `Shift-Alt-Right: Shift-Ctrl-Right` (select word right)

### `exact_match: true`

Only the exact modifier combination matches. Use this when you need a different action for the shifted variant:

```yaml
keymap:
  - name: Exact example
    exact_match: true
    remap:
      Super-n: Ctrl-n            # New window — only without Shift
      Shift-Super-n: Ctrl-Shift-n  # New folder — must be defined separately
```

`exact_match` can be set per-keymap-block. It applies to all rules in that block.

## `shared:` Section

The `shared` top-level key is ignored by xremap's config logic — it exists purely to define YAML anchors for reuse:

```yaml
shared:
  terminals: &terminals
    - /^alacritty$/
    - /^kitty$/
    - /^gnome-terminal/

  browsers: &browsers
    - /^firefox/i
    - /^google-chrome$/i
    - /^brave-browser$/i

  remotes: &remotes
    - /^anydesk$/i
    - /^virtualbox/i
    - /^remmina$/i

keymap:
  - name: General Terminals
    application:
      only: *terminals
    remap:
      Super-c: Ctrl-Shift-c

  - name: General Browsers
    application:
      only: *browsers
    remap:
      Alt-Super-i: Ctrl-Shift-i
```

## `keypress_delay_ms`

Adds a delay (in milliseconds) between synthesized key events from keymap rules. Useful when:
- Electron apps (VS Code, Slack) drop quickly-fired synthetic keys
- Wayland compositors miss rapid key sequences

```yaml
keypress_delay_ms: 10    # 10ms delay between each key in a sequence
```

This only affects keymap output, not modmap.

## `throttle_ms`

Slows all synthetic events globally (both modmap and keymap). Adds delay between press/release pairs and modifier transitions. Only adds delay when needed.

```yaml
throttle_ms: 20
```

## Virtual Modifiers

Promote any key to act as a modifier in keymap rules:

```yaml
virtual_modifiers:
  - CapsLock

keymap:
  - remap:
      CapsLock-j: Left       # CapsLock held + J = Left arrow
      CapsLock-k: Up
      CapsLock-l: Right
      CapsLock-semicolon: Down
```

Not used in our config (CapsLock→Ctrl is handled by XKB), but documented for reference.

## Mode System

Vim-style modal remapping. Not used in our config but available:

```yaml
default_mode: normal

keymap:
  - name: Normal mode
    mode: normal
    remap:
      i: { set_mode: insert }
      h: Left
      j: Down
      k: Up
      l: Right

  - name: Insert mode
    mode: insert
    remap:
      Escape: { set_mode: normal }
```

Modes apply to both modmap and keymap blocks. Omitting `mode` makes a block active in all modes.

## Multi-File Loading

Pass multiple config files to merge them:

```bash
xremap base.yml overrides.yml
```

`modmap`, `keymap`, and `virtual_modifiers` arrays are concatenated. Later files extend (not replace) earlier ones.

## Live Reload

```bash
# Watch for new input devices (hot-plug support)
xremap --watch config.yml

# Also reload config when file changes
xremap --watch=config config.yml

# Both: reload config + watch devices
xremap --watch=config,device config.yml
```

## Debug Logging

```bash
RUST_LOG=debug xremap config.yml
```

Shows:
- Which keymap/modmap block matched each key event
- The WM_CLASS and window title of the focused application
- Device information for each input event
- Rule evaluation and output key events
