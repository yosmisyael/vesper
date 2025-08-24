#!/usr/bin/env bash

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

# Script to manage screenshot folder destination

screenshot_folder="$HOME/Pictures/Screenshots"

# Alternative folders (uncomment to use):
# screenshot_folder="$HOME/Pictures"                    # Default Pictures folder
# screenshot_folder="$HOME/Desktop"                     # Desktop folder
# screenshot_folder="/tmp/screenshots"                  # Temporary folder
# screenshot_folder="$HOME/Documents/Screenshots"       # Documents subfolder

# Create screenshot folder if it doesn't exist
if [[ ! -d "$screenshot_folder" ]]; then
    mkdir -p "$screenshot_folder"
    echo "📁 Created screenshot folder: $screenshot_folder"
fi

# Ensure folder is writable
if [[ ! -w "$screenshot_folder" ]]; then
    echo "❌ Error: Screenshot folder is not writable: $screenshot_folder"
    echo "📁 Falling back to: $HOME/Pictures"
    screenshot_folder="$HOME/Pictures"
    mkdir -p "$screenshot_folder"
fi

# Export for use in other scripts
export SCREENSHOT_FOLDER="$screenshot_folder"
