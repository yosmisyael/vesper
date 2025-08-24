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

# Script to manage screenshot file name 

NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"

# Alternative formats (uncomment to use):
# NAME="screen_$(date +%Y-%m-%d_%H-%M-%S).png"              # ISO format with dashes
# NAME="capture_$(date +%d%b%Y_%H%M%S | tr '[:upper:]' '[:lower:]').png"  # Month abbreviation
# NAME="shot_$(date +%s).png"                               # Unix timestamp
# NAME="screenshot_$(date +%Y%m%d_%H%M%S)_$(hostname).png"   # Include hostname

# Export for use in other scripts
export SCREENSHOT_NAME="$NAME"
