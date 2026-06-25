#!/bin/bash

CONFIG_DIR="$HOME/.config"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

[[ $EUID -eq 0 ]] && error "Do not run as root"

echo -e "${RED}This will remove all installed configs.${NC}"
read -rp "Continue? [y/N] " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && { info "Cancelled."; exit 0; }

info "Removing config files..."

rm -rf \
    "$CONFIG_DIR/bspwm" \
    "$CONFIG_DIR/sxhkd" \
    "$CONFIG_DIR/picom" \
    "$CONFIG_DIR/compix" \
    "$CONFIG_DIR/polybar" \
    "$CONFIG_DIR/alacritty" \
    "$CONFIG_DIR/kitty" \
    "$CONFIG_DIR/rofi" \
    "$CONFIG_DIR/nvim" \
    "$CONFIG_DIR/fastfetch" \
    "$CONFIG_DIR/eww" \
    "$CONFIG_DIR/bat" \
    "$CONFIG_DIR/zathura"

rm -f "$HOME/.Xresources"
rm -f "$HOME/wall/whitewaves.jpg"
rmdir "$HOME/wall" 2>/dev/null || true

info "Config files removed."

echo ""
warn "Packages and binaries are NOT removed automatically."
warn "To remove packages:"
warn "  sudo apt remove bspwm sxhkd picom polybar alacritty kitty dunst rofi fastfetch xwallpaper dmenu maim stterm xsel neovim zathura bat"
warn "To remove compiled binaries:"
warn "  sudo rm -f /usr/local/bin/compix /usr/local/bin/eww"
