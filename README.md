<p align="center">
  <b>Evan's Linux Dotfiles</b>
</p>

<p align="center">
<img src="https://img.shields.io/github/stars/onlyv4ns/ubunturice?color=e5c76b&labelColor=22292b&style=for-the-badge">
<img src="https://img.shields.io/github/issues/onlyv4ns/ubunturice?color=67b0e8&labelColor=22292b&style=for-the-badge">
<img src="https://img.shields.io/static/v1?label=license&message=MIT&color=8ccf7e&labelColor=22292b&style=for-the-badge">
<img src="https://img.shields.io/github/forks/onlyv4ns/ubunturice?color=e74c4c&labelColor=1b2224&style=for-the-badge">
</p>

<br>

<img src="etc/screenshot.png" width="100%">

Personal BSPWM dotfiles using the [Everblush](https://github.com/mangeshrex/everblush.vim) colorscheme.

| Component | Tool |
|---|---|
| Window Manager | [BSPWM](https://github.com/baskerville/bspwm) |
| Hotkey Daemon | [sxhkd](https://github.com/baskerville/sxhkd) |
| Bar | [Polybar](https://github.com/polybar/polybar) |
| Compositor | [Compix](https://github.com/xeome/compix) |
| Terminal | [Alacritty](https://github.com/alacritty/alacritty) / [Kitty](https://sw.kovidgoyal.net/kitty) |
| Launcher | [Rofi](https://github.com/davatorium/rofi) |
| Widgets | [Eww](https://github.com/elkowar/eww) |
| Text Editor | [Neovim](https://neovim.io) |
| File Manager | [Thunar](https://docs.xfce.org/xfce/thunar/start) |
| System Info | [Fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| PDF Viewer | [Zathura](https://pwmt.org/projects/zathura) |

<br>

## Notes

- Colorscheme: [Everblush](https://github.com/mangeshrex/everblush.vim) — dark and easy on the eyes.
- Neovim colorscheme: [Tokyo Night](https://github.com/folke/tokyonight.nvim).
- Fonts: [JetBrainsMono Nerd Font](https://www.nerdfonts.com) and [Iosevka Nerd Font](https://www.nerdfonts.com). Install manually from Nerd Fonts.
- Alacritty uses TOML config format (`alacritty.toml`) — compatible with Alacritty v0.13+.

## Installation

```bash
git clone https://github.com/onlyv4ns/ubunturice ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script will automatically:
- Install all required packages via apt
- Build and install [compix](https://github.com/xeome/compix) and [eww](https://github.com/elkowar/eww) from source
- Copy all configs to `~/.config/`
- Install fonts and wallpaper

> **Post-install notes:**
> - Set your WiFi interface in `~/.config/polybar/config-git.ini` (default: `wlp3s0`)
> - Set your battery adapter name (default: `BAT0` / `ACAD`)
> - For touchpad natural scroll, uncomment the `xinput` line in `~/.config/bspwm/bspwmrc`
> - Open Neovim and run `:Lazy` to install plugins

## Uninstall

```bash
cd ~/dotfiles
./uninstall.sh
```

Removes all installed configs. Packages are not removed automatically — the commands to do so are shown when the script runs.
