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
# Script to manage brightness 
#
# by yosmisyael (2024)

current=$(brightnessctl -m | cut -d, -f4 | tr -d %)

if [[ "$1" == "up" ]]; then
    brightnessctl -q s +1%
else
    if [[ "$current" -gt 1 ]]; then
        brightnessctl -q s 1%-
    else
        brightnessctl -q s 1%
    fi
fi

if [ "$current" -le 20 ]; then
    icon="display-brightness-low-symbolic"
elif [ "$current" -le 70 ]; then
    icon="display-brightness-medium-symbolic"
else 
    icon="display-brightness-high-symbolic"
fi

notify-send \
    -h string:x-canonical-private-synchronous:sys-notify \
    -h int:value:"$current" \
    -i "$icon" \
    "Brightness: ${current}%" \
    -t 800
