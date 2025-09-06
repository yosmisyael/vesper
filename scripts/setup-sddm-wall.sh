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
# Script to setup wallpaper of sddm astronout theme 
# by yosmisyael (2024)


SDDM_THEME_BACKGROUND_PATH="/usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/Default.png"

NEW_WALLPAPER="$1"

if [ -z "$NEW_WALLPAPER" ]; then
    echo "Error: No wallpaper specified."
    echo "Usage: $0 /path/to/your/image.jpg"
    exit 1
fi 

if [ ! -f "$NEW_WALLPAPER" ]; then
    echo "Error: File not found at '$NEW_WALLPAPER'"
    exit 1
fi

magick "$NEW_WALLPAPER" "$SDDM_THEME_BACKGROUND_PATH"
