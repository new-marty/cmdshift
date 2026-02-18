# Toshy Translation Notes

How [Toshy](https://github.com/RedBearAK/toshy) Python/xwaykeyz concepts map to xremap YAML, and what doesn't translate directly.

## Core Translation Table

| Toshy Python | xremap YAML | Notes |
|---|---|---|
| `C("RC-c")` | `Super-c: Ctrl-c` | `RC` (Right Ctrl) = Toshy's virtualized Cmd = our `Super` after modmap |
| `C("LC-c")` | `Ctrl-c: Ctrl-c` (passthrough) | `LC` (Left Ctrl) = real Ctrl = unchanged |
| `C("C-c")` | `Ctrl-c: Ctrl-c` | Generic Ctrl = real Ctrl |
| `C("Alt-Left")` | `Alt-Left: Ctrl-Left` | `Alt` in Toshy = Option = our `Alt` after modmap |
| `C("Super-Tab")` | N/A (gsettings) | `Super` in Toshy's GUI context = physical Win key = our `Alt` after modmap. But Tab switching uses `bind` so it goes to gsettings |
| `C("Shift-RC-Left_Brace")` | `Shift-Super-Left_Brace: Ctrl-Page_Up` | Shift propagates naturally with `exact_match: false` |

### Modifier Mapping Summary

| Toshy Modifier | What It Is | Toshy Key | After Our Modmap | xremap Prefix |
|---|---|---|---|---|
| `RC` (Right Ctrl) | Virtualized Cmd | Physical varies by keyboard type | — | `Super-` |
| `LC` (Left Ctrl) | Real Control | Physical Ctrl | Ctrl (unchanged) | `Ctrl-` |
| `Alt` | Physical Alt/Option | Physical Alt | Super (after swap) | `Alt-` |
| `Super` | Physical Super/Win | Physical Super | Alt (after swap) | — (used in gsettings) |

> **Key insight:** Toshy virtualizes Cmd onto Right Ctrl via its modmap. We take a simpler approach — swap Alt↔Super so physical Alt (thumb position) becomes Super, which we treat as Cmd in all keymap rules.

## Application Matching

| Toshy Python | xremap YAML | Notes |
|---|---|---|
| `matchProps(clas="^alacritty$")` | `application: { only: [/^alacritty$/] }` | Direct regex translation |
| `matchProps(clas=termStr)` | `application: { only: [/^alacritty$/, /^kitty$/, ...] }` | Toshy joins list into single regex; xremap takes a list |
| `matchProps(not_clas=remoteStr)` | `application: { not: [/^anydesk$/i, ...] }` | Negative match |
| `matchProps(clas="...", name="...")` | `application: { only: [...] }` + `window: { only: [...] }` | xremap has separate `window:` filter |
| `matchProps(lst=some_lod)` | `application: { only: [...] }` + `window: { only: [...] }` | Toshy's "list of dicts" is complex; xremap approximates with separate filters |

### Toshy's `toRgxStr()` function

Toshy converts Python lists to a single regex string: `["alacritty", "kitty"]` → `"^alacritty$|^kitty$"`.

In xremap, provide each pattern as a separate list item:
```yaml
application:
  only:
    - /^alacritty$/
    - /^kitty$/
```

## Actions and Output

| Toshy Python | xremap YAML | Notes |
|---|---|---|
| `C("C-c")` | `Ctrl-c` | Single key combo output |
| `[C("Shift-End"), C("Backspace")]` | `[Shift-End, Backspace]` | Key sequence |
| `[C("Alt-e"), C("N")]` | `[Alt-e, n]` | Menu navigation sequence |
| `None` | (omit the rule) | Just don't define a mapping; key passes through |
| `ignore_combo` | (omit the rule) | Same — don't define it |
| `ST("text")` | `launch: ["xdotool", "type", "text"]` | String typing. No native xremap equivalent; use `launch` with xdotool |
| `sleep(0.1)` | `keypress_delay_ms: 100` (global) | Toshy can insert delays between steps in a sequence; xremap only has a global delay |
| `bind` | N/A (use gsettings) | Toshy's `bind` marks a shortcut as "held-modifier" — the modifier stays held. xremap cannot do this; use gsettings for held shortcuts |

### The `bind` keyword

In Toshy, prepending `bind` to an action tells xwaykeyz to keep the modifier held:
```python
C("RC-Tab"): [bind, C("Alt-Tab")]   # Alt stays held while Tab is tapped
```

xremap has no equivalent. Shortcuts requiring held-modifier behavior must be configured via gsettings or the native DE shortcut system. See [gnome-setup.md](gnome-setup.md).

## Concepts That Don't Translate

### `iEF2()` / `iEF2NT()` — Enter-to-Rename Toggle

Toshy's `iEF2` (isEnterToF2) is a stateful toggle function. It maintains a boolean variable that determines whether Enter sends `F2` (to rename a file) or `Enter` (to open/confirm):

```python
# Toshy: stateful — toggles between F2 and Enter based on context
C("Enter"):     iEF2(C("F2"), C("Enter"))     # F2 if rename mode, Enter otherwise
C("Esc"):       iEF2(C("Esc"), True)           # Escape resets to rename mode
C("Shift-RC-N"): iEF2(C("Shift-C-N"), False)   # New Folder resets to open mode
C("RC-L"):      iEF2(C("C-L"), False)           # Location bar resets to open mode
C("RC-F"):      iEF2(C("C-F"), False)           # Find resets to open mode
```

**Our simplification:** `Enter: F2` in file managers. This means Enter always renames. To open a file, use Cmd+Down (which sends Enter). This is simpler but less accurate than Toshy's approach.

`iEF2NT()` is the "no toggle" variant that only resets the state without sending a key.

### `isMultiTap()` — Multi-Tap Detection

Toshy can detect double-taps and triple-taps of a key combo:
```python
C("Shift-Alt-RC-i"): isMultiTap(
    tap_1_action=C("Shift-Alt-C-i"),    # single tap
    tap_2_action=notify_context,         # double tap
)
```

xremap has no multi-tap detection. A key combo always fires on the first press.

### `isDoubleTap()` — Double-Tap Detection (Deprecated)

Older version of `isMultiTap()`. Same limitation.

### DE-Conditional Logic

Toshy uses Python `if` statements for desktop environment-specific behavior:
```python
if DESKTOP_ENV == 'gnome':
    keymap("GenGUI overrides: GNOME", { ... })
if DESKTOP_ENV == 'kde':
    keymap("GenGUI overrides: KDE", { ... })
```

xremap has no conditionals. Solutions:
- **Target one DE** (our approach: GNOME only)
- **Use separate config files** per DE: `xremap gnome-config.yml` vs `xremap kde-config.yml`

### Keyboard Type Detection

Toshy detects keyboard type (Apple, Windows, Chromebook, IBM) from device names and applies different modmaps:
```python
if isKBtype('Apple'):     # Apple keyboard → different modmap
if isKBtype('Chromebook'): # Chromebook → Alt becomes Cmd
```

xremap approximation: Use `device:` filters in modmap blocks to apply different remaps per keyboard:
```yaml
modmap:
  - name: PC keyboard
    device:
      not: ['Apple Internal Keyboard']
    remap:
      Alt_L: Super_L
  - name: Apple keyboard
    device:
      only: ['Apple Internal Keyboard']
    remap:
      Super_L: Alt_L   # different swap for Apple layout
```

### Distro-Conditional Logic

Toshy has distro-specific overrides:
```python
if DISTRO_ID == 'ubuntu' and DESKTOP_ENV == 'gnome':
    keymap("GenGUI overrides: Ubuntu/Fedora", { ... })
```

No xremap equivalent. Our config targets Ubuntu GNOME specifically. For other distros, fork and adjust the gsettings and DE-specific shortcuts.

## Toshy Config Structure

Where to find things in `toshy_config.py` (from `default-toshy-config/`):

| Lines | Content |
|---|---|
| 1–80 | Imports, keymapper API settings, throttle delays |
| 80–150 | Modifier aliases (RC = virtualized Cmd) |
| 150–320 | Environment detection (DISTRO_ID, DESKTOP_ENV, etc.) |
| 320–420 | Variables, helper functions (ST, UC, ignore_combo, matchProps keys) |
| 420–475 | **Terminals list** (~45 entries) |
| 482–500 | **VS Code + Sublime Text lists** |
| 503–660 | **Other app lists** (remotes, browsers_chrome, browsers_firefox, browsers_all, filemanagers) |
| 660–715 | Dialog lists (Escape/Close handling) |
| 715–1850 | Keyboard type detection, modmap blocks (GUI and terminal modmaps per keyboard type) |
| 1850–1900 | Trigger keymaps (internal state management — skip) |
| 1900–2450 | Conditional modmaps (media keys, numpad, Caps2Cmd per keyboard type) |
| 2450–3400 | Dead keys + ABC Extended (Unicode input — low priority) |
| 3400–3750 | Option+key special characters (Unicode — low priority) |
| 3750–3860 | User hardware keys + misc apps (Thunderbird, Angry IP Scanner, Transmission, etc.) |
| 3860–4195 | **File manager keymaps** (per-app overrides then general) |
| 4195–4330 | **Browser keymaps** (Firefox, Chrome overrides then general) |
| 4330–4720 | **Code editor keymaps** (JetBrains, VS Code, Sublime Text) |
| 4720–5060 | Dialog fixes, tab nav fixes, terminal per-app overrides, General Terminals |
| 5060–5150 | Cmd+Dot → Escape, GenGUI keyboard type overrides |
| 5150–5500 | GenGUI distro/DE-specific overrides |
| 5500–5580 | **General GUI** (catch-all keymap) |
| 5580–5617 | Diagnostics (isMultiTap) |

## Translation Patterns

### Pattern 1: Simple combo → combo
```python
# Toshy
C("RC-c"):  C("C-c")     # Copy
```
```yaml
# xremap
Super-c: Ctrl-c
```

### Pattern 2: Combo → sequence
```python
# Toshy
C("RC-Backspace"): [C("Shift-Home"), C("Backspace")]
```
```yaml
# xremap
Super-Backspace: [Shift-Home, Backspace]
```

### Pattern 3: Terminal Cmd→Ctrl+Shift
```python
# Toshy
C("RC-C"):  C("C-Shift-C")    # Copy in terminal
```
```yaml
# xremap (in terminal keymap block)
Super-c: Ctrl-Shift-c
```

### Pattern 4: App-specific with dialog awareness
```python
# Toshy (complex — class + name matching with list of dicts)
matchProps(clas="^dolphin$|^org.kde.dolphin$", name="^Configure.*Dolphin$")
```
```yaml
# xremap (approximate)
application:
  only: [/^dolphin$/, /^org\.kde\.dolphin$/]
window:
  only: [/^Configure.*Dolphin$/]
```

### Pattern 5: Held-modifier shortcut
```python
# Toshy
C("RC-Tab"): [bind, C("Alt-Tab")]    # bind = keep modifier held
```
```yaml
# xremap — CANNOT DO THIS
# Instead, use gsettings:
# gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
```

### Pattern 6: Stateful toggle (no equivalent)
```python
# Toshy
C("Enter"): iEF2(C("F2"), C("Enter"))    # F2 or Enter depending on state
```
```yaml
# xremap — simplified to always F2
Enter: F2
# User opens files with Cmd+Down instead of Enter
```
