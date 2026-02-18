# Application Class Lists

WM_CLASS values for all supported applications, sourced from [Toshy's](https://github.com/RedBearAK/toshy) comprehensive lists. These are used in xremap's `application` filter to apply category-specific keymaps.

## How to Discover WM_CLASS on GNOME Wayland

```bash
# Method 1: GNOME Shell eval (works on Wayland)
gdbus call --session --dest org.gnome.Shell \
  --object-path /org/gnome/Shell \
  --method org.gnome.Shell.Eval \
  "global.get_window_actors().map(a=>a.meta_window.get_wm_class())"

# Method 2: xremap debug logging (shows class for each key event)
RUST_LOG=debug xremap config.yml

# Method 3: xprop (X11 only, does not work on Wayland)
xprop WM_CLASS

# Method 4: Looking Glass (GNOME built-in debugger)
# Alt+F2 → type "lg" → Windows tab → shows wm_class for each window
```

---

## Terminals

~45 terminal emulators. Used for the General Terminals keymap (Cmd+C → Ctrl+Shift+C, etc.).

| WM_CLASS | Application |
|---|---|
| `alacritty` | Alacritty |
| `com.raggesilver.BlackBox` | Black Box |
| `com.system76.CosmicTerm` | COSMIC Terminal |
| `contour` | Contour |
| `cutefish-terminal` | Cutefish Terminal |
| `deepin-terminal` | Deepin Terminal |
| `dev.warp.Warp` | Warp |
| `eterm` | Eterm |
| `.*ghostty.*` | Ghostty (all variants) |
| `gnome-terminal` | GNOME Terminal |
| `gnome-terminal-server` | GNOME Terminal (server) |
| `guake` | Guake |
| `hyper` | Hyper |
| `io.elementary.terminal` | elementary Terminal |
| `kitty` | Kitty |
| `Kgx` | GNOME Console (King's Cross) |
| `konsole` | Konsole |
| `lxterminal` | LXTerminal |
| `mate-terminal` | MATE Terminal |
| `MateTerminal` | MATE Terminal (alt) |
| `org.codeberg.dnkl.foot.desktop` | Foot |
| `org.gnome.Console` | GNOME Console |
| `org.gnome.Terminal` | GNOME Terminal (Flatpak) |
| `org.kde.konsole` | Konsole (KDE) |
| `org.kde.yakuake` | Yakuake |
| `org.wezfurlong.wezterm` | WezTerm (Flatpak) |
| `.*Ptyxis.*` | Ptyxis (all variants) |
| `roxterm` | ROXTerm |
| `qterminal` | QTerminal |
| `st` | st (suckless terminal) |
| `sakura` | Sakura |
| `station` | Station |
| `tabby` | Tabby |
| `terminator` | Terminator |
| `terminology` | Terminology |
| `termite` | Termite |
| `Termius` | Termius |
| `tilda` | Tilda |
| `tilix` | Tilix |
| `urxvt` | urxvt (rxvt-unicode) |
| `Wave` | Wave Terminal |
| `wezterm` | WezTerm |
| `wezterm-gui` | WezTerm GUI |
| `xfce4-terminal` | Xfce4 Terminal |
| `xterm` | xterm |
| `yakuake` | Yakuake |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^alacritty$/
    - /^com\.raggesilver\.blackbox$/
    - /^com\.system76\.cosmicterm$/
    - /^contour$/
    - /^cutefish-terminal$/
    - /^deepin-terminal$/
    - /^dev\.warp\.warp$/
    - /^eterm$/
    - /ghostty/
    - /^gnome-terminal/
    - /^guake$/
    - /^hyper$/
    - /^io\.elementary\.terminal$/
    - /^kitty$/
    - /^kgx$/
    - /^konsole$/
    - /^lxterminal$/
    - /^mate-?terminal$/i
    - /^org\.codeberg\.dnkl\.foot/
    - /^org\.gnome\.(Console|Terminal)$/
    - /^org\.kde\.(konsole|yakuake)$/
    - /^org\.wezfurlong\.wezterm$/
    - /ptyxis/i
    - /^roxterm$/
    - /^qterminal$/
    - /^st$/
    - /^sakura$/
    - /^station$/
    - /^tabby$/
    - /^terminator$/
    - /^terminology$/
    - /^termite$/
    - /^termius$/i
    - /^tilda$/
    - /^tilix$/
    - /^urxvt$/
    - /^wave$/i
    - /^wezterm/
    - /^xfce4-terminal$/
    - /^xterm$/
    - /^yakuake$/
```

---

## Firefox-Based Browsers

| WM_CLASS | Application |
|---|---|
| `firedragon` | FireDragon (Garuda fork) |
| `Firefox` | Firefox |
| `firefox_.*` | Firefox (Ubuntu variants) |
| `firefox-esr` | Firefox ESR |
| `Firefox Developer Edition` | Firefox Developer Edition |
| `firefoxdeveloperedition` | Firefox Dev Edition (alt) |
| `firefox-nightly.*` | Firefox Nightly |
| `floorp` | Floorp |
| `LibreWolf` | LibreWolf |
| `Mullvad Browser` | Mullvad Browser |
| `Navigator` | Navigator (legacy) |
| `org.mozilla.firefox` | Firefox (Flatpak) |
| `Waterfox` | Waterfox |
| `zen-browser` | Zen Browser |
| `zen` | Zen Browser (alt) |
| `zen-alpha` | Zen Browser Alpha |
| `zen-beta` | Zen Browser Beta |
| `zen-bin` | Zen Browser (binary) |
| `zen-twilight` | Zen Browser Twilight |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^firedragon$/
    - /^firefox/i
    - /^firefoxdeveloperedition$/
    - /^floorp$/
    - /^librewolf$/i
    - /^mullvad browser$/i
    - /^navigator$/i
    - /^org\.mozilla\.firefox$/
    - /^waterfox$/i
    - /^zen/i
```

---

## Chrome-Based Browsers

| WM_CLASS | Application |
|---|---|
| `Brave-browser` | Brave |
| `Chromium` | Chromium |
| `Chromium-browser` | Chromium (alt) |
| `Falkon` | Falkon |
| `Google-chrome` | Google Chrome |
| `Io.github.ungoogled_software.ungoogled_chromium` | Ungoogled Chromium |
| `microsoft-edge` | Microsoft Edge |
| `microsoft-edge-dev` | Microsoft Edge Dev |
| `org.deepin.browser` | Deepin Browser |
| `org.kde.falkon` | Falkon (KDE) |
| `.*ungoogled_chromium` | Ungoogled Chromium (alt) |
| `Vivaldi.*` | Vivaldi |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^brave-browser$/i
    - /^chromium/i
    - /^falkon$/i
    - /^google-chrome$/i
    - /ungoogled.chromium/i
    - /^microsoft-edge/i
    - /^org\.deepin\.browser$/
    - /^org\.kde\.falkon$/
    - /^vivaldi/i
```

---

## All Browsers (Combined)

Includes all Firefox-based + Chrome-based browsers plus:

| WM_CLASS | Application |
|---|---|
| `Discord` | Discord (Electron, browser-like) |
| `Epiphany` | GNOME Web (Epiphany) |
| `org.gnome.Epiphany` | GNOME Web (Flatpak) |

---

## File Managers

| WM_CLASS | Application |
|---|---|
| `caja` | Caja (MATE) |
| `com.system76.CosmicFiles` | COSMIC Files |
| `dde-file-manager` | DDE File Manager (Deepin) |
| `dolphin` | Dolphin (KDE) |
| `io.elementary.files` | Pantheon Files (elementary) |
| `krusader` | Krusader (KDE alt) |
| `nautilus` | Nautilus (GNOME Files) |
| `nemo` | Nemo (Cinnamon) |
| `org.gnome.nautilus` | Nautilus (Flatpak) |
| `org.kde.dolphin` | Dolphin (KDE, Flatpak) |
| `org.kde.krusader` | Krusader (KDE, Flatpak) |
| `pcmanfm` | PCManFM (LXDE) |
| `pcmanfm-qt` | PCManFM-Qt (LXQt) |
| `peony-qt` | Peony-Qt (UKUI) |
| `spacefm` | SpaceFM |
| `thunar` | Thunar (Xfce) |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^caja$/
    - /^com\.system76\.cosmicfiles$/i
    - /^dde-file-manager$/
    - /^dolphin$/
    - /^io\.elementary\.files$/
    - /^krusader$/
    - /^nautilus$/
    - /^nemo$/
    - /^org\.gnome\.nautilus$/
    - /^org\.kde\.(dolphin|krusader)$/
    - /^pcmanfm(-qt)?$/
    - /^peony-qt$/
    - /^spacefm$/i
    - /^thunar$/
```

---

## VS Code Variants

| WM_CLASS | Application |
|---|---|
| `code` | Visual Studio Code |
| `code - oss` | VS Code OSS (with space) |
| `code-oss` | VS Code OSS |
| `cursor` | Cursor (AI-powered VS Code fork) |
| `vscodium` | VSCodium |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^code(-oss| - oss)?$/i
    - /^cursor$/
    - /^vscodium$/
```

---

## Sublime Text

| WM_CLASS | Application |
|---|---|
| `sublime_text` | Sublime Text |
| `subl` | Sublime Text (alt) |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^subl(ime_text)?$/
```

---

## JetBrains IDEs

All JetBrains IDEs share a common WM_CLASS pattern: `jetbrains-<product>`.
The toolbox app is excluded since it doesn't need IDE keybindings.

| WM_CLASS Pattern | Application |
|---|---|
| `jetbrains-idea` | IntelliJ IDEA |
| `jetbrains-pycharm` | PyCharm |
| `jetbrains-webstorm` | WebStorm |
| `jetbrains-clion` | CLion |
| `jetbrains-goland` | GoLand |
| `jetbrains-rider` | Rider |
| `jetbrains-phpstorm` | PhpStorm |
| `jetbrains-rubymine` | RubyMine |
| `jetbrains-datagrip` | DataGrip |
| `jetbrains-fleet` | Fleet |
| `jetbrains-rust-rover` | RustRover |

**xremap regex pattern:**
```yaml
application:
  only:
    - /^jetbrains-(?!.*toolbox)/
```

---

## Remote Desktop / VM Clients

These apps are **excluded** from the General GUI keymap since they handle their own key remapping for the remote OS.

| WM_CLASS | Application |
|---|---|
| `Anydesk` | AnyDesk |
| `Gnome-boxes` | GNOME Boxes |
| `gnome-connections` | GNOME Connections |
| `org.gnome.Boxes` | GNOME Boxes (Flatpak) |
| `org.remmina.Remmina` | Remmina |
| `Nxplayer.bin` | NoMachine |
| `remmina` | Remmina (alt) |
| `qemu-system-.*` | QEMU |
| `qemu` | QEMU (alt) |
| `Spicy` | Spice client |
| `Virt-manager` | Virtual Machine Manager |
| `VirtualBox` | VirtualBox |
| `VirtualBox Machine` | VirtualBox Machine |
| `xfreerdp` | xfreerdp |
| `Wfica` | Citrix Workspace |

**xremap regex pattern:**
```yaml
application:
  not:
    - /^anydesk$/i
    - /^gnome-(boxes|connections)$/i
    - /^org\.gnome\.boxes$/i
    - /^org\.remmina\.remmina$/i
    - /^nxplayer/i
    - /^remmina$/i
    - /^qemu/i
    - /^spicy$/i
    - /^virt-manager$/i
    - /^virtualbox/i
    - /^xfreerdp$/i
    - /^wfica$/i
```

---

## Other Matched Applications

These apps have specific override keymaps:

| WM_CLASS | Application | Override Type |
|---|---|---|
| `thunderbird.*` / `org.mozilla.thunderbird` | Thunderbird | Tab nav, dev tools |
| `Angry.*IP.*Scanner` | Angry IP Scanner | Preferences, info |
| `Transmission-gtk` / `Transmission-qt` / `com.transmissionbt.Transmission.*` | Transmission | Properties, preferences |
| `totem` | Totem (Videos) | Stop = quit |
| `eog` | Eye of GNOME | Image properties |
| `libreoffice-writer` | LibreOffice Writer | Preferences |
| `org.kde.kate` | Kate | Preferences, find |
| `xed` | xed (Mint text editor) | New tab |
| `kwrite` / `org.kde.Kwrite` | KWrite | Preferences |
| `gnome-text-editor` / `org.gnome.TextEditor` | GNOME Text Editor | — |
| `.*Zotero.*` | Zotero | Import from clipboard |
