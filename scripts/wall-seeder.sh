#!/bin/bash

#                                                                
#                                                                
#     /$$    /$$ /$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$ 
#    |  $$  /$$//$$__  $$ /$$_____/ /$$__  $$ /$$__  $$ /$$__  $$
#     \  $$/$$/| $$$$$$$$|  $$$$$$ | $$  \ $$| $$$$$$$$| $$  \__/
#      \  $$$/ | $$_____/ \____  $$| $$  | $$| $$_____/| $$      
#       \  $/  |  $$$$$$$ /$$$$$$$/| $$$$$$$/|  $$$$$$$| $$      
#        \_/    \_______/|_______/ | $$____/  \_______/|__/      
#                                  | $$                          
#                                  | $$                          
#                                  |__/
#
# by yosmisyael (2024)

# Script to change wallpaper randomly

wallpaper_dir="$HOME/.config/wallpaper/"

current_wallpaper=$(swww query | grep -o 'image: .*' | sed 's/image: //')

new_wallpaper=$(find "$wallpaper_dir" -type f | grep -v -F -x "$current_wallpaper" | shuf -n 1)

if [ -z "$new_wallpaper" ]; then
    echo "No other wallpapers to choose from."
    exit 0
fi

if [[ -z "new_wallpaper" ]]; then
  echo "Error: Could not get new wallpaper from swww"
  exit 1 
fi 

$HOME/.config/vesper/scripts/theme.sh "$new_wallpaper"

