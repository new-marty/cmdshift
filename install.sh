#!/usr/bin/env bash
# install.sh — One-time setup for cmdshift (xremap macOS-style keybindings)
#
# What this does:
#   1. Installs xremap binary (via cargo or GitHub release)
#   2. Installs xremap-gnome GNOME Shell extension
#   3. Sets up udev rules + input group for /dev/input access
#   4. Deploys config.yml to ~/.config/xremap/
#   5. Installs and enables systemd user service
#   6. Runs setup-gnome.sh for gsettings (Layer 3)
#
# Usage: ./install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$1"; }
fail() { printf "${RED}✗${NC} %s\n" "$1"; exit 1; }
step() { printf "\n${BOLD}▸ %s${NC}\n" "$1"; }

# --- Pre-flight checks ---
if [[ "$XDG_SESSION_TYPE" != "wayland" ]] 2>/dev/null; then
    warn "This config is designed for Wayland. Current session: ${XDG_SESSION_TYPE:-unknown}"
fi

if ! command -v gnome-shell &>/dev/null; then
    warn "GNOME Shell not detected. This config targets GNOME."
fi

# =========================================================================
# Step 1: Install xremap binary
# =========================================================================
step "Installing xremap"

if command -v xremap &>/dev/null; then
    ok "xremap already installed: $(xremap --version 2>&1 || echo 'unknown version')"
else
    if command -v cargo &>/dev/null; then
        echo "Installing xremap via cargo (with GNOME support)..."
        cargo install xremap --features gnome
        ok "xremap installed via cargo"
    else
        echo "cargo not found. Installing xremap from GitHub releases..."
        ARCH=$(uname -m)
        case "$ARCH" in
            x86_64) ARCH_SUFFIX="x86_64" ;;
            aarch64) ARCH_SUFFIX="aarch64" ;;
            *) fail "Unsupported architecture: $ARCH" ;;
        esac

        LATEST=$(curl -sL "https://api.github.com/repos/xremap/xremap/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ -z "$LATEST" ]]; then
            fail "Could not determine latest xremap release. Install manually: cargo install xremap --features gnome"
        fi

        DOWNLOAD_URL="https://github.com/xremap/xremap/releases/download/${LATEST}/xremap-linux-${ARCH_SUFFIX}-gnome.zip"
        TMPDIR=$(mktemp -d)
        echo "Downloading xremap ${LATEST}..."
        curl -sL "$DOWNLOAD_URL" -o "$TMPDIR/xremap.zip"
        unzip -q "$TMPDIR/xremap.zip" -d "$TMPDIR"
        mkdir -p "$HOME/.local/bin"
        mv "$TMPDIR/xremap" "$HOME/.local/bin/xremap"
        chmod +x "$HOME/.local/bin/xremap"
        rm -rf "$TMPDIR"
        ok "xremap ${LATEST} installed to ~/.local/bin/xremap"
    fi
fi

# =========================================================================
# Step 2: Install xremap GNOME Shell extension
# =========================================================================
step "Checking xremap GNOME Shell extension"

EXTENSION_UUID="xremap@k0kubun.com"
if gnome-extensions list 2>/dev/null | grep -q "$EXTENSION_UUID"; then
    ok "xremap GNOME Shell extension already installed"
else
    warn "xremap GNOME Shell extension not found"
    echo "Install it from: https://extensions.gnome.org/extension/5060/xremap/"
    echo "Or via: gnome-extensions install $EXTENSION_UUID"
    echo ""
    echo "This extension is REQUIRED for application-aware remapping on Wayland."
    echo "After installing, enable it: gnome-extensions enable $EXTENSION_UUID"
fi

# =========================================================================
# Step 3: Set up udev rules + input group
# =========================================================================
step "Setting up input device access"

UDEV_RULE="/etc/udev/rules.d/99-xremap.rules"
if [[ -f "$UDEV_RULE" ]]; then
    ok "udev rule already exists at $UDEV_RULE"
else
    echo "Creating udev rule for input device access (requires sudo)..."
    sudo tee "$UDEV_RULE" > /dev/null << 'UDEV'
KERNEL=="uinput", GROUP="input", MODE="0660"
KERNEL=="event*", NAME="input/%k", MODE="0660", GROUP="input"
UDEV
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    ok "udev rule created"
fi

if groups "$USER" | grep -qw input; then
    ok "User $USER is already in the input group"
else
    echo "Adding $USER to input group (requires sudo)..."
    sudo usermod -aG input "$USER"
    ok "Added $USER to input group (reboot required to take effect)"
fi

# =========================================================================
# Step 4: Deploy config
# =========================================================================
step "Deploying xremap config"

CONFIG_DIR="$HOME/.config/xremap"
mkdir -p "$CONFIG_DIR"
cp "$SCRIPT_DIR/config.yml" "$CONFIG_DIR/config.yml"
ok "Config deployed to $CONFIG_DIR/config.yml"

# =========================================================================
# Step 5: Install and enable systemd service
# =========================================================================
step "Setting up systemd service"

SERVICE_DIR="$HOME/.config/systemd/user"
mkdir -p "$SERVICE_DIR"
cp "$SCRIPT_DIR/xremap.service" "$SERVICE_DIR/xremap.service"
systemctl --user daemon-reload
systemctl --user enable xremap.service
ok "Service installed and enabled"

# Start if possible (might fail without reboot for input group)
if systemctl --user start xremap.service 2>/dev/null; then
    ok "Service started"
else
    warn "Service could not start yet (may need reboot for input group)"
fi

# =========================================================================
# Step 6: Apply GNOME settings
# =========================================================================
step "Applying GNOME gsettings"

bash "$SCRIPT_DIR/setup-gnome.sh"

# =========================================================================
# Done
# =========================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "${GREEN}${BOLD}Setup complete!${NC}\n"
echo ""
if ! groups "$USER" | grep -qw input; then
    printf "${YELLOW}${BOLD}⚠  REBOOT REQUIRED${NC}\n"
    echo "   You were added to the 'input' group. Reboot for it to take effect."
    echo ""
fi
echo "Verify with:"
echo "  systemctl --user status xremap.service"
echo "  RUST_LOG=debug xremap ~/.config/xremap/config.yml"
echo ""
echo "Chezmoi integration:"
echo "  config.yml      → dot_config/xremap/config.yml"
echo "  xremap.service  → dot_config/systemd/user/xremap.service"
echo "  setup-gnome.sh  → run_onchange_setup-gnome.sh"
echo "  install.sh      → run_once_install-xremap.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
