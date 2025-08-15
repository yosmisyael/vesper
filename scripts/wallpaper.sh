#!/bin/bash

wallpaper_dir="$HOME/.config/wallpaper/"

current_wallpaper=$(swww query | grep -o 'image: .*' | sed 's/image: //')

new_wallpaper=$(find "$wallpaper_dir" -type f | grep -v -F -x "$current_wallpaper" | shuf -n 1)

if [ -z "$new_wallpaper" ]; then
    echo "No other wallpapers to choose from."
    exit 0
fi

# Function to generate blurred version
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

# Function to generate thumbnail
generate_thumbnail() {
    local input="$1"
    local output="$2"
    
    # Create high-quality thumbnail with proper centering and aspect ratio
    # Based on the provided script: strip metadata, resize with quality control
    if command -v magick &> /dev/null; then
        magick "${input}"[0] -strip -resize 1000 -gravity center -extent 1000 -quality 90 "$output"
    elif command -v convert &> /dev/null; then
        convert "${input}"[0] -strip -resize 1000 -gravity center -extent 1000 -quality 90 "$output"
    else
        echo "Error: ImageMagick not found. Please install it."
        exit 1
    fi
}

if [[ -z "new_wallpaper" ]]; then
  echo "Error: Could not get new wallpaper from swww"
  exit 1 
fi 

CACHE_DIR="$HOME/.cache/rofi"
mkdir -p "$CACHE_DIR"
BLUR_OUTPUT="$CACHE_DIR/wall.blur"
THUMB_OUTPUT="$CACHE_DIR/wall.thmb"

generate_blur "$new_wallpaper" "$BLUR_OUTPUT"
generate_thumbnail "$new_wallpaper" "$THUMB_OUTPUT"

swww img "$new_wallpaper" --transition-type center --transition-step 15 --transition-fps 60

matugen image "$new_wallpaper"


