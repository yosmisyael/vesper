#!/bin/bash

# Rofi Wallpaper Cache Generator for swww
# This script fetches the current wallpaper and generates cached versions for Rofi

# Create cache directory if it doesn't exist
CACHE_DIR="$HOME/.cache/rofi"
mkdir -p "$CACHE_DIR"

# Function to get current wallpaper from swww
get_current_wallpaper() {
    # Get the current wallpaper path from swww using the correct parsing
    local wallpaper_path=$(swww query | grep -o 'image: .*' | sed 's/image: //')
    
    # Remove any trailing whitespace
    wallpaper_path=$(echo "$wallpaper_path" | xargs)
    
    if [[ -f "$wallpaper_path" ]]; then
        echo "$wallpaper_path"
    else
        echo ""
    fi
}

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


# Main execution
main() {
    echo "🎨 Rofi Wallpaper Cache Generator"
    echo "================================"
    
    # Get current wallpaper
    CURRENT_WALLPAPER=$(get_current_wallpaper)
    
    if [[ -z "$CURRENT_WALLPAPER" ]]; then
        echo "❌ Error: Could not get current wallpaper from swww"
        echo "   Make sure swww is running and has set a wallpaper"
        exit 1
    fi
    
    echo "📁 Current wallpaper: $CURRENT_WALLPAPER"
    
    # Define output paths
    BLUR_OUTPUT="$CACHE_DIR/wall.blur"
    THUMB_OUTPUT="$CACHE_DIR/wall.thmb"
    SQUARE_OUTPUT="$CACHE_DIR/wall.sqre"
    
    # Generate blurred background
    echo "🔄 Generating blurred background..."
    generate_blur "$CURRENT_WALLPAPER" "$BLUR_OUTPUT"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Blurred background saved to: $BLUR_OUTPUT"
    else
        echo "❌ Failed to generate blurred background"
        exit 1
    fi
    
    # Generate thumbnail
    echo "🔄 Generating thumbnail..."
    generate_thumbnail "$CURRENT_WALLPAPER" "$THUMB_OUTPUT"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Thumbnail saved to: $THUMB_OUTPUT"
    else
        echo "❌ Failed to generate thumbnail"
        exit 1
    fi
     
    echo "Cache generation complete!"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
