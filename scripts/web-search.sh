#!/bin/bash
#
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
# Script to perform web search 
#

THEME="$HOME/.config/rofi/web-search.rasi"
BROWSER="$HOME/.config/vesper/scripts/browser.sh"
QUERY=$(rofi -dmenu -theme "$THEME" -p "")

if [ -z "$QUERY" ]; then
    exit 0
fi 

if [[ "$QUERY" =~ ^(http|https|www\.) ]] || [[ "$QUERY" =~ \.(com|net|org|io|edu|id)$ ]]; then
     "$BROWSER" "$QUERY"
else
    "$BROWSER" "https://www.google.com/search?q=${QUERY}"
fi
