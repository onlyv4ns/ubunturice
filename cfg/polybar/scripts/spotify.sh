#!/usr/bin/env bash

STATUS=$(playerctl --player=spotify status 2>/dev/null)

if [ -z "$STATUS" ] || [ "$STATUS" = "No players found" ]; then
    echo ""
    exit 0
fi

ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)
TITLE=$(playerctl --player=spotify metadata title 2>/dev/null)

if [ -z "$ARTIST" ] && [ -z "$TITLE" ]; then
    echo ""
    exit 0
fi

if [ "$STATUS" = "Playing" ]; then
    ICON=""
else
    ICON=""
fi

LABEL="$ARTIST - $TITLE"
MAX=40
if [ ${#LABEL} -gt $MAX ]; then
    LABEL="${LABEL:0:$MAX}..."
fi

echo "$ICON  $LABEL"
