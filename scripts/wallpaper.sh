#!/bin/bash

WALL_DIR="$HOME/.config/wallpaper"

SELECTED_FILE=$(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) \
                -printf "%f\0icon\037%p\n" | rofi -dmenu -p "" -theme ~/.config/rofi/wallpaper.rasi)

if [ -n "$SELECTED_FILE" ]; then
    FULL_PATH="$WALL_DIR/$SELECTED_FILE"
    "$HOME/.config/vesper/scripts/theme.sh" $FULL_PATH
fi
