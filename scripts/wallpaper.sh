#!/bin/bash

WALL_DIR="$HOME/.config/wallpapers"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"

# fetch all wallpapers
mapfile -d '' files_full_path < <(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) -print0)

# prepare them as rofi input
SELECTED_FILENAME=$(
    for path in "${files_full_path[@]}"; do
        filename="${path##*/}"
        printf "%s\0icon\x1f%s\n" "$filename" "$path"
    done | rofi -dmenu -replace -config "$ROFI_THEME" -show-icons
)

# get the selected item full path
if [ -n "$SELECTED_FILENAME" ]; then
    SELECTED_PATH=""
    for path in "${files_full_path[@]}"; do
        if [[ "${path##*/}" == "$SELECTED_FILENAME" ]]; then
            SELECTED_PATH="$path"
            break
        fi
    done

    # execute theme script
    if [ -n "$SELECTED_PATH" ]; then
        "$HOME/.config/vesper/scripts/theme.sh" "$SELECTED_PATH"
    fi
fi
