#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

[[ $EUID -eq 0 ]] && error "Do not run as root"

info "Installing packages via apt..."
sudo apt-get update -qq
sudo apt-get install -y \
    bspwm sxhkd picom polybar alacritty kitty dunst rofi fastfetch \
    xwallpaper dmenu maim stterm xsel neovim zathura bat \
    i3lock flameshot brightnessctl nsxiv \
    libxcomposite-dev libxdamage-dev libxfixes-dev libxrender-dev \
    libx11-dev libxext-dev libxrandr-dev \
    libconfuse-dev libxdg-basedir-dev \
    libgtk-3-dev libglib2.0-dev libdbusmenu-glib-dev libdbusmenu-gtk3-dev \
    build-essential git curl unzip

if ! command -v cargo &>/dev/null; then
    info "Installing Rust (required for eww)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
source "$HOME/.cargo/env" 2>/dev/null || true

if ! command -v clipmenu &>/dev/null; then
    info "Building clipnotify and clipmenu from source..."
    TMP=$(mktemp -d)
    git clone --depth=1 https://github.com/cdown/clipnotify "$TMP/clipnotify"
    make -C "$TMP/clipnotify"
    sudo cp "$TMP/clipnotify/clipnotify" /usr/local/bin/
    git clone --depth=1 https://github.com/cdown/clipmenu "$TMP/clipmenu"
    sudo make -C "$TMP/clipmenu" install
    rm -rf "$TMP"
    info "clipmenu installed"
else
    info "clipmenu already exists, skipping"
fi

if ! command -v compix &>/dev/null; then
    info "Building compix from source..."
    TMP=$(mktemp -d)
    git clone https://github.com/xeome/compix "$TMP/compix"
    make -C "$TMP/compix" all
    sudo cp "$TMP/compix/out/compix" /usr/local/bin/compix
    rm -rf "$TMP"
    info "compix installed"
else
    info "compix already exists, skipping"
fi

if ! command -v eww &>/dev/null; then
    info "Building eww from source (this may take ~1-2 minutes)..."
    TMP=$(mktemp -d)
    git clone https://github.com/elkowar/eww "$TMP/eww" --depth=1
    (cd "$TMP/eww" && cargo build --release --no-default-features --features x11)
    sudo cp "$TMP/eww/target/release/eww" /usr/local/bin/eww
    rm -rf "$TMP"
    info "eww installed"
else
    info "eww already exists, skipping"
fi

BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
info "Backing up existing configs to $BACKUP_DIR ..."
mkdir -p "$BACKUP_DIR"
for d in bspwm sxhkd picom compix polybar alacritty kitty rofi eww bat zathura neovim fastfetch; do
    [[ -d "$HOME/.config/$d" ]] && cp -r "$HOME/.config/$d" "$BACKUP_DIR/$d" && info "  backed up: ~/.config/$d"
done
[[ -f "$HOME/.Xresources" ]] && cp "$HOME/.Xresources" "$BACKUP_DIR/.Xresources" && info "  backed up: ~/.Xresources"

info "Creating config directories..."
mkdir -p \
    "$CONFIG_DIR/bspwm" \
    "$CONFIG_DIR/sxhkd" \
    "$CONFIG_DIR/picom" \
    "$CONFIG_DIR/compix" \
    "$CONFIG_DIR/polybar/scripts" \
    "$CONFIG_DIR/alacritty" \
    "$CONFIG_DIR/kitty" \
    "$CONFIG_DIR/rofi/themes" \
    "$CONFIG_DIR/neovim" \
    "$CONFIG_DIR/fastfetch" \
    "$CONFIG_DIR/eww/systray/scripts" \
    "$CONFIG_DIR/eww/systray/windows/settings-panel" \
    "$CONFIG_DIR/bat/themes" \
    "$CONFIG_DIR/zathura" \
    "$CONFIG_DIR/dunst" \
    "$HOME/wall" \
    "$HOME/.local/share/fonts" \
    "$HOME/.local/share/applications" \
    "$HOME/.local/bin" \
    "$CONFIG_DIR/gtk-3.0" \
    "$CONFIG_DIR/gtk-4.0"

info "Copying config files..."

cp "$DOTFILES_DIR/cfg/bspwm/bspwmrc"              "$CONFIG_DIR/bspwm/bspwmrc"
chmod +x "$CONFIG_DIR/bspwm/bspwmrc"

cp "$DOTFILES_DIR/cfg/sxhkd/sxhkdrc"              "$CONFIG_DIR/sxhkd/sxhkdrc"

cp "$DOTFILES_DIR/cfg/picom/picom.conf"            "$CONFIG_DIR/picom/picom.conf"
cp "$DOTFILES_DIR/cfg/compix/compix.conf"          "$CONFIG_DIR/compix/compix.conf"

cp "$DOTFILES_DIR/cfg/polybar/config-git.ini"      "$CONFIG_DIR/polybar/config-git.ini"
cp "$DOTFILES_DIR/cfg/polybar/scripts/"*.sh        "$CONFIG_DIR/polybar/scripts/"
chmod +x "$CONFIG_DIR/polybar/scripts/"*.sh

cp "$DOTFILES_DIR/cfg/alacritty/alacritty.toml"   "$CONFIG_DIR/alacritty/alacritty.toml"
cp "$DOTFILES_DIR/cfg/kitty/kitty.conf"            "$CONFIG_DIR/kitty/kitty.conf"

cp "$DOTFILES_DIR/cfg/rofi/config.rasi"            "$CONFIG_DIR/rofi/config.rasi"
cp "$DOTFILES_DIR/cfg/rofi/powermenu.rasi"         "$CONFIG_DIR/rofi/powermenu.rasi"
cp "$DOTFILES_DIR/cfg/rofi/launcher.rasi"          "$CONFIG_DIR/rofi/launcher.rasi"
cp "$DOTFILES_DIR/cfg/rofi/themes/"*.rasi          "$CONFIG_DIR/rofi/themes/"

cp -r "$DOTFILES_DIR/cfg/eww/systray/"            "$CONFIG_DIR/eww/"
chmod +x "$CONFIG_DIR/eww/systray/scripts/"*

cp "$DOTFILES_DIR/cfg/bat/config"                  "$CONFIG_DIR/bat/config"
cp "$DOTFILES_DIR/cfg/bat/themes/"*               "$CONFIG_DIR/bat/themes/"

cp "$DOTFILES_DIR/cfg/zathura/zathurarc"           "$CONFIG_DIR/zathura/zathurarc"

cp "$DOTFILES_DIR/cfg/neovim/init.lua"             "$CONFIG_DIR/nvim/init.lua"

cp "$DOTFILES_DIR/cfg/fastfetch/config.jsonc"      "$CONFIG_DIR/fastfetch/config.jsonc"

cp "$DOTFILES_DIR/cfg/.Xresources"                "$HOME/.Xresources"

cp "$DOTFILES_DIR/cfg/dunst/dunstrc"               "$CONFIG_DIR/dunst/dunstrc"

cp -r "$DOTFILES_DIR/bin/"*                        "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*

cp "$DOTFILES_DIR/cfg/gtk-3.0/settings.ini"       "$CONFIG_DIR/gtk-3.0/settings.ini"
cp "$DOTFILES_DIR/cfg/gtk-4.0/settings.ini"        "$CONFIG_DIR/gtk-4.0/settings.ini"
cp "$DOTFILES_DIR/cfg/gtk-4.0/gtk.css"             "$CONFIG_DIR/gtk-4.0/gtk.css"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

cp "$DOTFILES_DIR/cfg/applications/google-chrome.desktop" "$HOME/.local/share/applications/google-chrome.desktop"
cp "$DOTFILES_DIR/cfg/applications/mimeapps.list"        "$CONFIG_DIR/mimeapps.list"

mkdir -p "$HOME/.local/share/chrome-theme"
cp -r "$DOTFILES_DIR/cfg/chrome-theme/"* "$HOME/.local/share/chrome-theme/"
info "Chrome theme copied to ~/.local/share/chrome-theme/"
info "  To apply: open chrome://extensions → enable Developer mode → Load unpacked → select that folder"

# Vencord (Discord mod) — install if Discord exists and Vencord not yet patched
if command -v discord &>/dev/null && [[ ! -d "$HOME/.config/Vencord/dist" ]]; then
    info "Installing Vencord for Discord..."
    TMP=$(mktemp -d)
    curl -sL "https://api.github.com/repos/Vendicated/VencordInstaller/releases/latest" \
      | python3 -c "import sys,json; r=json.load(sys.stdin); [print(a['browser_download_url']) for a in r.get('assets',[]) if 'Cli-linux' in a['name']]" \
      | xargs curl -sL -o "$TMP/VencordInstallerCli"
    chmod +x "$TMP/VencordInstallerCli"
    expect << EXPECT
spawn $TMP/VencordInstallerCli install
expect "What would you like to do"
send "\r"
expect "Select Discord install"
send "\r"
expect eof
EXPECT
    info "Vencord installed"
fi
# Download Vencord dist files if missing
VENCORD_DIST="$HOME/.config/Vencord/dist"
if [[ ! -f "$VENCORD_DIST/patcher.js" ]]; then
    info "Downloading Vencord dist files..."
    mkdir -p "$VENCORD_DIST"
    BASE="https://github.com/Vendicated/Vencord/releases/download/devbuild"
    for f in patcher.js preload.js renderer.js renderer.css; do
        curl -sL "$BASE/$f" -o "$VENCORD_DIST/$f"
    done
fi
mkdir -p "$HOME/.config/Vencord/themes"
cp "$DOTFILES_DIR/cfg/discord/everblush.css" "$HOME/.config/Vencord/themes/everblush.css"
info "Discord theme copied — enable it in Discord: Vencord Settings → Themes"

# Firefox userChrome — requires toolkit.legacyUserProfileCustomizations.stylesheets = true in about:config
FF_PROFILE=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
if [[ -n "$FF_PROFILE" ]]; then
    mkdir -p "$FF_PROFILE/chrome"
    cp -r "$DOTFILES_DIR/cfg/firefox/chrome/"* "$FF_PROFILE/chrome/"
    info "Firefox chrome installed to $FF_PROFILE/chrome/"
else
    warn "Firefox profile not found — run Firefox once, then re-run this script to install the theme"
fi

info "Copying wallpaper..."
cp "$DOTFILES_DIR/etc/wallpaper.jpg" "$HOME/wall/wallpaper.jpg"
xwallpaper --zoom "$HOME/wall/wallpaper.jpg" &

info "Installing fonts..."
cp "$DOTFILES_DIR/fonts/"*.ttf   "$HOME/.local/share/fonts/" 2>/dev/null || true
cp "$DOTFILES_DIR/fonts/"*.eot   "$HOME/.local/share/fonts/" 2>/dev/null || true
cp "$DOTFILES_DIR/fonts/"*.woff  "$HOME/.local/share/fonts/" 2>/dev/null || true
cp "$DOTFILES_DIR/fonts/"*.woff2 "$HOME/.local/share/fonts/" 2>/dev/null || true
if [[ -f "$DOTFILES_DIR/fonts/CascadiaCode.zip" ]]; then
    unzip -qo "$DOTFILES_DIR/fonts/CascadiaCode.zip" -d "$HOME/.local/share/fonts/"
fi
fc-cache -f "$HOME/.local/share/fonts/"

echo ""
info "Installation complete!"
warn "Notes:"
warn "  - Set your WiFi interface in polybar config (default: wlp3s0)"
warn "  - Set your battery adapter name (default: BAT0 / ACAD)"
warn "  - For touchpad natural scroll, uncomment the xinput line in bspwmrc"
warn "  - Install JetBrainsMono Nerd Font & Iosevka Nerd Font manually"
warn "  - Open Neovim and run :Lazy to install plugins"
info "Log out and select the BSPWM session to get started."
