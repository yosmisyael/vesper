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

# Script to manage theme by wallpaper 
# Usage:
#     ./theme.sh /path/to/wallpaper [supported png and jpg] 

if [ -z "$1" ]; then
  echo "Usage: $(basename "$0") /path/to/your/wallpaper"
  exit 1
fi 

wallpaper_path="$1"

if [ ! -f "$wallpaper_path" ]; then
    echo "Error: File not found at '$wallpaper_path'"
    exit 1
fi 

generate_blur() {
    local input="$1"
    local output="$2"
    
    if command -v magick &> /dev/null; then
        magick "${input}"[0] -strip -scale 10% -blur 0x3 -resize 100% "$output"
    elif command -v convert &> /dev/null; then
        convert "${input}"[0] -strip -scale 10% -blur 0x3 -resize 100% "$output"
    else
        echo "Error: ImageMagick not found. Please install it."
        exit 1
    fi
}

generate_thumbnail() {
    local input="$1"
    local output="$2"
    
    if command -v magick &> /dev/null; then
        magick "${input}"[0] -strip -resize 1000 -gravity center -extent 1000 -quality 90 "$output"
    elif command -v convert &> /dev/null; then
        convert "${input}"[0] -strip -resize 1000 -gravity center -extent 1000 -quality 90 "$output"
    else
        echo "Error: ImageMagick not found. Please install it."
        exit 1
    fi
}

generate_profile() {
    local input="$1"
    local output="$2"

    if command -v magick &> /dev/null; then
        magick "${input}" -gravity center -crop 1:1 -resize 500x500 -strip "$output"
    elif command -v convert &> /dev/null; then
        convert "${input}" -gravity center -crop 1:1 -resize 500x500 -strip "$output"
    else
        echo "Error: ImageMagick not found. Please install it."
        exit 1
    fi
}

cache_dir="$HOME/.cache/vesper"
mkdir -p "$cache_dir"
output_blur="$cache_dir/wall.blur"
output_thumb="$cache_dir/wall.thmb"
output_profile="$cache_dir/profile.jpg"

generate_blur "$wallpaper_path" "$output_blur"
generate_thumbnail "$wallpaper_path" "$output_thumb"
generate_profile "$wallpaper_path" "$output_profile"

swww img "$wallpaper_path" --transition-type center --transition-step 15 --transition-fps 60

matugen image "$wallpaper_path"
