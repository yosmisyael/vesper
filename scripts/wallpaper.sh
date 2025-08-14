#!/bin/bash

wallpaper_dir="$HOME/.config/wallpaper/"

current_wallpaper=$(swww query | grep -o 'image: .*' | sed 's/image: //')

new_wallpaper=$(find "$wallpaper_dir" -type f | grep -v -F -x "$current_wallpaper" | shuf -n 1)

if [ -z "$new_wallpaper" ]; then
    echo "No other wallpapers to choose from."
    exit 0
fi

swww img "$new_wallpaper" --transition-type center --transition-step 15 --transition-fps 60

matugen image "$new_wallpaper"
