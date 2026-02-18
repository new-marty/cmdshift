# Keybinding Reference

Complete mapping table from macOS shortcuts to Linux actions via xremap.

**Column key:**
- **Mac Shortcut** — what you'd press on macOS
- **Physical Keys (PC)** — what you press on the PC keyboard
- **xremap Rule** — the keymap entry (after modmap, physical Alt = Super = "Cmd")
- **App Receives** — what the application actually sees

> After the Alt↔Super modmap: `Super-` = Cmd (physical Alt), `Alt-` = Option (physical Super), `Ctrl-` = Ctrl

---

## Standard GUI Shortcuts

These apply to all non-remote apps via the General GUI keymap.

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+C | Alt+C | `Super-c: Ctrl-c` | Ctrl+C | Copy |
| Cmd+V | Alt+V | `Super-v: Ctrl-v` | Ctrl+V | Paste |
| Cmd+X | Alt+X | `Super-x: Ctrl-x` | Ctrl+X | Cut |
| Cmd+Z | Alt+Z | `Super-z: Ctrl-z` | Ctrl+Z | Undo |
| Cmd+Shift+Z | Alt+Shift+Z | (auto from exact_match:false) | Ctrl+Shift+Z | Redo |
| Cmd+A | Alt+A | `Super-a: Ctrl-a` | Ctrl+A | Select All |
| Cmd+S | Alt+S | `Super-s: Ctrl-s` | Ctrl+S | Save |
| Cmd+Shift+S | Alt+Shift+S | (auto) | Ctrl+Shift+S | Save As |
| Cmd+W | Alt+W | `Super-w: Ctrl-w` | Ctrl+W | Close Tab/Window |
| Cmd+Q | Alt+Q | `Super-q: Alt-F4` | Alt+F4 | Quit Application |
| Cmd+T | Alt+T | `Super-t: Ctrl-t` | Ctrl+T | New Tab |
| Cmd+N | Alt+N | `Super-n: Ctrl-n` | Ctrl+N | New Window |
| Cmd+F | Alt+F | `Super-f: Ctrl-f` | Ctrl+F | Find |
| Cmd+G | Alt+G | `Super-g: Ctrl-g` | Ctrl+G | Find Next |
| Cmd+Shift+G | Alt+Shift+G | (auto) | Ctrl+Shift+G | Find Previous |
| Cmd+P | Alt+P | `Super-p: Ctrl-p` | Ctrl+P | Print |
| Cmd+O | Alt+O | `Super-o: Ctrl-o` | Ctrl+O | Open |
| Cmd+R | Alt+R | `Super-r: Ctrl-r` | Ctrl+R | Refresh/Reload |
| Cmd+L | Alt+L | `Super-l: Ctrl-l` | Ctrl+L | Address bar / Go to |
| Cmd+, | Alt+, | `Super-comma: Ctrl-comma` | Ctrl+, | Preferences |

## Navigation (Wordwise)

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+Left | Alt+Left | `Super-Left: Home` | Home | Beginning of Line |
| Cmd+Right | Alt+Right | `Super-Right: End` | End | End of Line |
| Cmd+Up | Alt+Up | `Super-Up: Ctrl-Home` | Ctrl+Home | Beginning of File |
| Cmd+Down | Alt+Down | `Super-Down: Ctrl-End` | Ctrl+End | End of File |
| Cmd+Shift+Left | Alt+Shift+Left | (auto) | Shift+Home | Select to Beginning of Line |
| Cmd+Shift+Right | Alt+Shift+Right | (auto) | Shift+End | Select to End of Line |
| Cmd+Shift+Up | Alt+Shift+Up | (auto) | Ctrl+Shift+Home | Select to Beginning of File |
| Cmd+Shift+Down | Alt+Shift+Down | (auto) | Ctrl+Shift+End | Select to End of File |
| Option+Left | Super+Left | `Alt-Left: Ctrl-Left` | Ctrl+Left | Word Left |
| Option+Right | Super+Right | `Alt-Right: Ctrl-Right` | Ctrl+Right | Word Right |
| Option+Shift+Left | Super+Shift+Left | (auto) | Ctrl+Shift+Left | Select Word Left |
| Option+Shift+Right | Super+Shift+Right | (auto) | Ctrl+Shift+Right | Select Word Right |

### Emacs-style Text Navigation (intentionally omitted)

macOS Cocoa text fields natively support Ctrl+A/E/B/F/N/P/K/D for Emacs-style line
navigation. These are **not** remapped here because on Linux, the Ctrl+letter combos
conflict with standard application shortcuts:

- **Ctrl+A** — Select All
- **Ctrl+F** — Find
- **Ctrl+N** — New Window
- **Ctrl+P** — Print
- **Ctrl+K** — Used by various apps (Slack: link, VS Code: chord prefix)
- **Ctrl+B** — Bold, bookmarks
- **Ctrl+D** — Bookmark/duplicate

Use Cmd+Arrow equivalents instead: Cmd+Left/Right (Home/End) and Cmd+Up/Down
(Ctrl+Home/Ctrl+End) for line and file navigation.

## Delete Operations

### General GUI

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Option+Backspace | Super+Backspace | `Alt-Backspace: Ctrl-Backspace` | Ctrl+Backspace | Delete Word Left |
| Option+Delete | Super+Delete | `Alt-Delete: Ctrl-Delete` | Ctrl+Delete | Delete Word Right |
| Cmd+Backspace | Alt+Backspace | `Super-Backspace: [Shift-Home, Backspace]` | (sequence) | Delete Line Left |
| Cmd+Delete | Alt+Delete | `Super-Delete: [Shift-End, Delete]` | (sequence) | Delete Line Right |

### Terminal-specific

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Option+Backspace | Super+Backspace | `Alt-Backspace: Ctrl-w` | Ctrl+W | Delete Word Left (readline) |
| Option+Delete | Super+Delete | `Alt-Delete: [Esc, d]` | Esc,d | Delete Word Right (readline) |
| Cmd+Backspace | Alt+Backspace | `Super-Backspace: Ctrl-u` | Ctrl+U | Delete Line Left (readline) |
| Cmd+Delete | Alt+Delete | `Super-Delete: Ctrl-k` | Ctrl+K | Delete Line Right (readline) |

## App Switching (GNOME gsettings — NOT xremap keymap)

| Mac Shortcut | Physical Keys | gsettings Binding | Action |
|---|---|---|---|
| Cmd+Tab | Alt+Tab | `<Super>Tab` | Switch applications |
| Cmd+Shift+Tab | Alt+Shift+Tab | `<Shift><Super>Tab` | Switch applications (reverse) |
| Cmd+` | Alt+` | `<Super>Above_Tab` | Switch windows of same app |
| Cmd+Shift+` | Alt+Shift+` | `<Shift><Super>Above_Tab` | Switch windows (reverse) |

## Tab Navigation

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+Shift+[ | Alt+Shift+[ | `Shift-Super-Left_Brace: Ctrl-Page_Up` | Ctrl+PgUp | Previous Tab |
| Cmd+Shift+] | Alt+Shift+] | `Shift-Super-Right_Brace: Ctrl-Page_Down` | Ctrl+PgDn | Next Tab |
| Cmd+Option+Left | Alt+Super+Left | `Super-Alt-Left: Ctrl-Page_Up` | Ctrl+PgUp | Previous Tab (browsers) |
| Cmd+Option+Right | Alt+Super+Right | `Super-Alt-Right: Ctrl-Page_Down` | Ctrl+PgDn | Next Tab (browsers) |
| Cmd+Shift+T | Alt+Shift+T | (auto) | Ctrl+Shift+T | Reopen Closed Tab |
| Ctrl+Tab | Ctrl+Tab | (terminals only) `Ctrl-Tab: Ctrl-Page_Down` | Ctrl+PgDn | Next Tab (terminal) |
| Ctrl+Shift+Tab | Ctrl+Shift+Tab | (terminals only) `Ctrl-Shift-Tab: Ctrl-Page_Up` | Ctrl+PgUp | Previous Tab (terminal) |

## Terminal-Specific

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+C | Alt+C | `Super-c: Ctrl-Shift-c` | Ctrl+Shift+C | Copy (not SIGINT) |
| Cmd+V | Alt+V | `Super-v: Ctrl-Shift-v` | Ctrl+Shift+V | Paste |
| Cmd+T | Alt+T | `Super-t: Ctrl-Shift-t` | Ctrl+Shift+T | New Tab |
| Cmd+N | Alt+N | `Super-n: Ctrl-Shift-n` | Ctrl+Shift+N | New Window |
| Cmd+W | Alt+W | `Super-w: Ctrl-Shift-w` | Ctrl+Shift+W | Close Tab |
| Cmd+F | Alt+F | `Super-f: Ctrl-Shift-f` | Ctrl+Shift+F | Find |
| Cmd+D | Alt+D | `Super-d: Ctrl-Shift-d` | Ctrl+Shift+D | Split Horizontal |
| Cmd+K | Alt+K | `Super-k: Ctrl-l` | Ctrl+L | Clear Screen (some terminals) |
| Cmd+- | Alt+- | `Super-Minus: Ctrl-Minus` | Ctrl+- | Decrease Font Size |
| Cmd+= | Alt+= | `Super-Equal: Ctrl-Shift-Equal` | Ctrl+Shift+= | Increase Font Size |
| Cmd+. | Alt+. | `Super-Dot: Ctrl-c` | Ctrl+C | Cancel/SIGINT |

## Browser-Specific

### Firefox Browsers

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+Option+I | Alt+Super+I | `Alt-Super-i: Shift-Ctrl-i` | Ctrl+Shift+I | Dev Tools |
| Cmd+Option+J | Alt+Super+J | `Alt-Super-j: Shift-Ctrl-j` | Ctrl+Shift+J | Console |
| Cmd+Shift+N | Alt+Shift+N | `Shift-Super-n: Ctrl-Shift-p` | Ctrl+Shift+P | Private Window (Firefox) |
| Cmd+1..9 | Alt+1..9 | `Super-1: Alt-1` ... | Alt+1..9 | Jump to Tab # (Firefox) |
| Cmd+Y | Alt+Y | `Super-y: Ctrl-h` | Ctrl+H | History (Chrome) |

### Chrome Browsers

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+Q | Alt+Q | `Super-q: Alt-F4` | Alt+F4 | Quit Browser |
| Cmd+[ | Alt+[ | `Super-Left_Brace: Alt-Left` | Alt+Left | Back |
| Cmd+] | Alt+] | `Super-Right_Brace: Alt-Right` | Alt+Right | Forward |
| Cmd+Y | Alt+Y | `Super-y: Ctrl-h` | Ctrl+H | History |
| Cmd+Option+U | Alt+Super+U | `Alt-Super-u: Ctrl-u` | Ctrl+U | View Source |
| Cmd+Shift+J | Alt+Shift+J | `Shift-Super-j: Ctrl-j` | Ctrl+J | Downloads |

## File Manager-Specific

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Enter | Enter | `Enter: F2` | F2 | Rename (simplified from Toshy's iEF2) |
| Cmd+I | Alt+I | `Super-i: Alt-Enter` | Alt+Enter | Get Info (Properties) |
| Cmd+Backspace | Alt+Backspace | `Super-Backspace: Delete` | Delete | Move to Trash |
| Cmd+Shift+. | Alt+Shift+. | `Shift-Super-Dot: Ctrl-h` | Ctrl+H | Toggle Hidden Files |
| Cmd+Up | Alt+Up | `Super-Up: Alt-Up` | Alt+Up | Go to Parent Directory |
| Cmd+Down | Alt+Down | `Super-Down: Enter` | Enter | Open Folder/File |
| Cmd+[ | Alt+[ | `Super-Left_Brace: Alt-Left` | Alt+Left | Go Back |
| Cmd+] | Alt+] | `Super-Right_Brace: Alt-Right` | Alt+Right | Go Forward |
| Cmd+Shift+[ | Alt+Shift+[ | `Shift-Super-Left_Brace: Ctrl-Page_Up` | Ctrl+PgUp | Previous Tab |
| Cmd+Shift+] | Alt+Shift+] | `Shift-Super-Right_Brace: Ctrl-Page_Down` | Ctrl+PgDn | Next Tab |
| Cmd+Shift+N | Alt+Shift+N | `Shift-Super-n: Ctrl-Shift-n` | Ctrl+Shift+N | New Folder |
| Cmd+, | Alt+, | `Super-comma: [Alt-e, n]` | (sequence) | Preferences |
| Cmd+Option+O | Alt+Super+O | `Alt-Super-o: Ctrl-Shift-o` | Ctrl+Shift+O | Open in New Window/Tab |

### Nautilus-Specific Overrides

| xremap Rule | App Receives | Action |
|---|---|---|
| `Super-1: Ctrl-2` | Ctrl+2 | View as Icons |
| `Super-2: Ctrl-1` | Ctrl+1 | View as List |
| `Alt-Super-o: Ctrl-Enter` | Ctrl+Enter | Open in New Tab |
| `Super-comma: Ctrl-comma` | Ctrl+, | Preferences |

## VS Code-Specific

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Ctrl+` | Ctrl+` | `Alt-Grave: Ctrl-Grave` | Ctrl+` | Toggle Terminal |
| Ctrl+Shift+` | Ctrl+Shift+` | `Shift-Alt-Grave: Ctrl-Shift-Grave` | Ctrl+Shift+` | New Terminal |
| Cmd+. | Alt+. | `Super-Dot: Ctrl-Dot` | Ctrl+. | QuickFix (overrides global Escape) |
| Cmd+C | Alt+C | `Super-c: Ctrl-Insert` | Ctrl+Insert | Copy (works in embedded terminal) |
| Cmd+Option+C | Alt+Super+C | `Alt-Super-c: Alt-c` | Alt+C | Find: Toggle Match Case |
| Cmd+Option+W | Alt+Super+W | `Alt-Super-w: Alt-w` | Alt+W | Find: Toggle Whole Word |
| Cmd+Option+R | Alt+Super+R | `Alt-Super-r: Alt-r` | Alt+R | Find: Toggle Regex |
| Cmd+Option+L | Alt+Super+L | `Alt-Super-l: Alt-l` | Alt+L | Find: Toggle Find in Selection |
| Cmd+Enter | Alt+Enter | `Super-Enter: Ctrl-Alt-Enter` | Ctrl+Alt+Enter | Replace All |
| Cmd+Option+Z | Alt+Super+Z | `Alt-Super-z: Alt-z` | Alt+Z | Toggle Word Wrap |
| Cmd+Option+Up | Alt+Super+Up | `Alt-Super-Up: Shift-Alt-Up` | Shift+Alt+Up | Add Cursor Above |
| Cmd+Option+Down | Alt+Super+Down | `Alt-Super-Down: Shift-Alt-Down` | Shift+Alt+Down | Add Cursor Below |
| Cmd+Shift+[ | Alt+Shift+[ | `Shift-Super-Left_Brace: Ctrl-Page_Up` | Ctrl+PgUp | Previous Editor Tab |
| Cmd+Shift+] | Alt+Shift+] | `Shift-Super-Right_Brace: Ctrl-Page_Down` | Ctrl+PgDn | Next Editor Tab |
| Cmd+G | Alt+G | `Super-g: Ctrl-g` | Ctrl+G | Go to Line |
| Cmd+Option+F | Alt+Super+F | `Alt-Super-f: Ctrl-h` | Ctrl+H | Replace |
| Ctrl+Shift+G | Ctrl+Shift+G | `Shift-Alt-g: Shift-Ctrl-g` | Ctrl+Shift+G | Source Control |
| Cmd+Backspace | Alt+Backspace | `Super-Backspace: [Shift-Home, Delete]` | (sequence) | Delete Line Left |
| Cmd+Delete | Alt+Delete | `Super-Delete: [Shift-End, Delete]` | (sequence) | Delete Line Right |

## JetBrains IDE-Specific

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+0..9 | Alt+0..9 | `Super-0: Alt-0` ... | Alt+0..9 | Open Tool Window |
| Cmd+, | Alt+, | `Super-comma: Ctrl-Alt-s` | Ctrl+Alt+S | Settings |
| Cmd+; | Alt+; | `Super-semicolon: Ctrl-Alt-Shift-s` | Ctrl+Alt+Shift+S | Project Structure |
| Cmd+O | Alt+O | `Super-o: Ctrl-n` | Ctrl+N | Go to Class |
| Cmd+Shift+O | Alt+Shift+O | `Shift-Super-o: Ctrl-Shift-n` | Ctrl+Shift+N | Go to File |
| Cmd+Option+O | Alt+Super+O | `Alt-Super-o: Ctrl-Alt-Shift-n` | Ctrl+Alt+Shift+N | Go to Symbol |
| Cmd+L | Alt+L | `Super-l: Ctrl-g` | Ctrl+G | Go to Line |
| Cmd+R | Alt+R | `Super-r: Shift-F10` | Shift+F10 | Run |
| Cmd+D | Alt+D | `Super-d: Shift-F9` | Shift+F9 | Debug |
| Cmd+G | Alt+G | `Super-g: F3` | F3 | Find Next |
| Cmd+B | Alt+B | `Super-b: Ctrl-b` | Ctrl+B | Go to Declaration |
| Cmd+E | Alt+E | `Super-e: Ctrl-e` | Ctrl+E | Recent Files |
| Cmd+Shift+F | Alt+Shift+F | (auto) | Ctrl+Shift+F | Find in Path |
| Cmd+Shift+R | Alt+Shift+R | `Shift-Super-r: Ctrl-Shift-F10` | Ctrl+Shift+F10 | Run Context Config |
| Cmd+Option+R | Alt+Super+R | `Alt-Super-r: F9` | F9 | Resume |
| Cmd+T | Alt+T | `Super-t: Ctrl-Alt-Shift-t` | Ctrl+Alt+Shift+T | Refactor This |
| Option+Up | Super+Up | `Alt-Up: Ctrl-w` | Ctrl+W | Extend Selection |
| Option+Down | Super+Down | `Alt-Down: Ctrl-Shift-w` | Ctrl+Shift+W | Shrink Selection |
| Option+Delete | Super+Delete | `Alt-Delete: Ctrl-Delete` | Ctrl+Delete | Delete to Word End |
| Option+Backspace | Super+Backspace | `Alt-Backspace: Ctrl-Backspace` | Ctrl+Backspace | Delete to Word Start |
| Cmd+Backspace | Alt+Backspace | `Super-Backspace: Ctrl-y` | Ctrl+Y | Delete Line |

## Sublime Text-Specific

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Action |
|---|---|---|---|---|
| Cmd+Option+F | Alt+Super+F | `Super-Alt-f: F11` | F11 | Toggle Full Screen |
| Cmd+G | Alt+G | `Super-g: F3` | F3 | Find Next |
| Cmd+Shift+G | Alt+Shift+G | `Shift-Super-g: Shift-F3` | Shift+F3 | Find Previous |
| Ctrl+Option+G | Ctrl+Super+G | `Ctrl-Alt-g: Alt-F3` | Alt+F3 | Find All Under |
| Cmd+Option+F | Alt+Super+F | `Alt-Super-f: Ctrl-h` | Ctrl+H | Replace |
| Cmd+Shift+Up | Alt+Shift+Up | `Shift-Super-Up: Alt-Shift-Up` | Alt+Shift+Up | Multi-cursor Up |
| Cmd+Shift+Down | Alt+Shift+Down | `Shift-Super-Down: Alt-Shift-Down` | Alt+Shift+Down | Multi-cursor Down |
| Cmd+Option+Up | Alt+Super+Up | `Alt-Super-Up: Ctrl-Up` | Ctrl+Up | Scroll Up |
| Cmd+Option+Down | Alt+Super+Down | `Alt-Super-Down: Ctrl-Down` | Ctrl+Down | Scroll Down |
| Cmd+Option+1..4 | Alt+Super+1..4 | `Alt-Super-1: Alt-Shift-1` ... | Alt+Shift+1..4 | Set Layout |
| Ctrl+Option+Up | Ctrl+Super+Up | `Ctrl-Alt-Up: Alt-o` | Alt+O | Switch File |
| Cmd+Option+V | Alt+Super+V | `Alt-Super-v: [Ctrl-k, Ctrl-v]` | (sequence) | Paste from History |

## Window Management (GNOME gsettings)

| Mac Shortcut | Physical Keys | gsettings Binding | Action |
|---|---|---|---|
| Cmd+H | Alt+H | `<Super>h` | Minimize (Hide) |
| Cmd+M | Alt+M | `<Super>m` | Minimize |
| Ctrl+Cmd+F | Ctrl+Alt+F | `<Ctrl><Super>f` | Toggle Maximize |
| Ctrl+Cmd+Q | Ctrl+Alt+Q | `<Ctrl><Super>q` | Lock Screen |
| Cmd+Shift+3 | Alt+Shift+3 | `Shift-Print` | Screenshot (Full) |
| Cmd+Shift+4 | Alt+Shift+4 | `Alt-Print` | Screenshot (Window) |
| Cmd+Shift+5 | Alt+Shift+5 | `Print` | Screenshot (Interactive) |

## Cmd+Dot → Escape

| Mac Shortcut | Physical Keys | xremap Rule | App Receives | Scope |
|---|---|---|---|---|
| Cmd+. | Alt+. | `Super-Dot: Escape` | Escape | All non-terminal apps |
| Cmd+. | Alt+. | `Super-Dot: Ctrl-c` | Ctrl+C | Terminals only (cancel) |
| Cmd+. | Alt+. | `Super-Dot: Ctrl-Dot` | Ctrl+. | VS Code only (QuickFix) |
