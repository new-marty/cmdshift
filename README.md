# cmdshift

A comprehensive [xremap](https://github.com/xremap/xremap) configuration providing macOS-style keyboard shortcuts on Linux. Built as a clean, Rust-based alternative to [Toshy](https://github.com/RedBearAK/toshy) — all keybinding logic lives in a single YAML file with no Python runtime dependency.

## Why

If you switch between macOS and Linux, maintaining consistent muscle memory is painful. This project translates the complete set of macOS keyboard conventions — Cmd+C/V/X, Cmd+Arrow navigation, Option+Delete word-deletion, Cmd+Tab app switching, and hundreds more — into xremap rules targeting GNOME on Wayland.

## Prerequisites

- **xremap** installed with GNOME Wayland support (`--features gnome`)
- **GNOME Shell xremap extension** — required for application-aware remapping on Wayland ([xremap/xremap-gnome](https://github.com/xremap/xremap-gnome))
- **CapsLock→Ctrl via XKB** (optional but recommended): `gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"`

## Quick Start

### Automated install

```bash
git clone https://github.com/YOUR_USER/cmdshift.git
cd cmdshift
./install.sh
```

This installs xremap, deploys the config, sets up the systemd service, and applies GNOME settings. You'll need to reboot after the first run (for input group membership).

### Manual install

1. Install xremap with GNOME support: `cargo install xremap --features gnome`
2. Install the [xremap GNOME Shell extension](https://extensions.gnome.org/extension/5060/xremap/)
3. Copy the config: `mkdir -p ~/.config/xremap && cp config.yml ~/.config/xremap/`
4. Apply GNOME settings: `./setup-gnome.sh`
5. Run xremap: `xremap --watch=config,device ~/.config/xremap/config.yml`

### Chezmoi integration

Copy these files into your chezmoi source directory:

| Source | Chezmoi target |
|--------|----------------|
| `config.yml` | `dot_config/xremap/config.yml` |
| `xremap.service` | `dot_config/systemd/user/xremap.service` |
| `setup-gnome.sh` | `run_onchange_setup-gnome.sh` |
| `install.sh` | `run_once_install-xremap.sh` |

## Architecture

Three-layer design:

| Layer | Purpose | Mechanism |
|-------|---------|-----------|
| **Modmap** | Alt↔Super swap (physical Alt = Cmd, physical Super = Option) | xremap `modmap` |
| **Keymap** | ~200 combo translation rules, ordered specific→general | xremap `keymap` |
| **gsettings** | System shortcuts needing held-modifier state (Alt-Tab, minimize) | GNOME `gsettings` |

See [docs/architecture.md](docs/architecture.md) for the full design deep-dive.

## What's Included

- **General GUI** — standard shortcuts (Cmd+C/V/X/Z/A/S/W/T/N/F/P etc.), navigation (Cmd+Arrow), delete operations (Option+Backspace, Cmd+Backspace)
- **Terminals** — Cmd+C = copy (not SIGINT), Cmd+V = paste, readline-compatible delete shortcuts, font size
- **Browsers** — dev tools, numbered tab navigation, back/forward, private window (Firefox + Chrome variants)
- **File Managers** — Enter=rename, Cmd+Backspace=trash, Cmd+Up=parent directory, properties
- **VS Code** — terminal toggle, QuickFix, multi-cursor, find option toggles
- **JetBrains IDEs** — tool windows, go to class/file/symbol, run/debug
- **Sublime Text** — full screen, multi-cursor, layout splits, find variants
- **Window Management** — minimize, maximize, screenshots (via gsettings)
- **Per-app overrides** — Ghostty, Kitty, Konsole, Nautilus, Dolphin, Thunderbird, and more

## What's Not Included (Yet)

- Dead keys / Unicode character input (Option+key special characters)
- Apple keyboard support (different modmap needed)
- Non-GNOME desktop environments (KDE, Xfce, Sway, etc.)
- Stateful Enter-to-Rename toggle (Toshy's `iEF2` state machine)
- Multi-tap detection (Toshy's `isMultiTap`)

## Documentation

| File | Description |
|------|-------------|
| [docs/architecture.md](docs/architecture.md) | Three-layer design, block ordering, evdev pipeline |
| [docs/keybinding-reference.md](docs/keybinding-reference.md) | Complete Mac→Linux mapping table by category |
| [docs/app-class-lists.md](docs/app-class-lists.md) | WM_CLASS values for all supported applications |
| [docs/xremap-config-guide.md](docs/xremap-config-guide.md) | xremap YAML syntax reference and patterns |
| [docs/gnome-setup.md](docs/gnome-setup.md) | Required gsettings changes and rationale |
| [docs/toshy-translation-notes.md](docs/toshy-translation-notes.md) | Toshy→xremap concept mapping and limitations |

## Credits

- [Toshy](https://github.com/RedBearAK/toshy) by RedBearAK — the comprehensive keybinding reference this project translates from
- [Kinto](https://github.com/rbreaves/kinto/) by Ben Reaves — the original project that Toshy forked from
- [xremap](https://github.com/xremap/xremap) — the Rust-based keymapper powering this config
