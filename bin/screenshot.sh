#!/bin/bash
SAVEDIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVEDIR"
FILENAME="$SAVEDIR/$(date +%Y%m%d_%H%M%S).png"

CHOICE=$(printf "󰹑  Fullscreen\n  Select Area\n󰹑  Fullscreen → Clipboard\n  Select Area → Clipboard\n  Annotate (Flameshot)" \
  | rofi -dmenu \
    -p "Screenshot" \
    -theme "$HOME/.config/rofi/launcher.rasi" \
    -no-custom)

case "$CHOICE" in
  *"Fullscreen"*"Clipboard") maim | xclip -selection clipboard -t image/png
    notify-send "Screenshot" "Fullscreen copied to clipboard" ;;
  *"Select Area"*"Clipboard") maim -s | xclip -selection clipboard -t image/png
    notify-send "Screenshot" "Selection copied to clipboard" ;;
  *"Fullscreen"*) maim "$FILENAME"
    notify-send "Screenshot" "Saved to $FILENAME" ;;
  *"Select Area"*) maim -s "$FILENAME"
    notify-send "Screenshot" "Saved to $FILENAME" ;;
  *"Annotate"*) flameshot gui ;;
esac
