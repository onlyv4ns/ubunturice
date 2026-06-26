#!/bin/bash
WALL_DIR="$HOME/wall"
wall=$(find "$WALL_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)
[ -z "$wall" ] && exit 1
xwallpaper --zoom "$wall"
