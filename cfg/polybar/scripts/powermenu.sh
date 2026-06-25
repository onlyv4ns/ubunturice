#!/usr/bin/env bash

SHUTDOWN="󰐥  Shutdown"
RESTART="󰜉  Restart"
LOGOUT="󰍃  Logout"

CHOSEN=$(printf "%s\n%s\n%s" "$SHUTDOWN" "$RESTART" "$LOGOUT" \
  | rofi -dmenu \
    -p "Power" \
    -theme "$HOME/.config/rofi/powermenu.rasi" \
    -no-custom)

case "$CHOSEN" in
  "$SHUTDOWN") systemctl poweroff ;;
  "$RESTART")  systemctl reboot ;;
  "$LOGOUT")   bspc quit ;;
esac
