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

# Script to manage hyprland logout and system power 

options="󰌾\n\n󰍃\n󰜉\n󰐥"

chosen="$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/logout.rasi -p "")"

case $chosen in
    "󰌾")
        hyprlock
        ;;
    "")
        systemctl suspend
        ;;
    "󰍃")
        hyprctl dispatch exit
        ;;
    "󰜉")
        systemctl reboot
        ;;
    "󰐥")
        systemctl poweroff
        ;;
    *)
        ;;
esac
