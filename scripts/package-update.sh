#!/bin/bash 

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

# Script to check system packages update

AUR_HELPER="paru"

THRESHHOLD_YELLOW=25
THRESHHOLD_RED=100

if [ -f "/var/lib/pacman/db.lck" ]; then
    printf '{"text": "󰌾", "tooltip": "Pacman database is locked", "class": "red"}'
    exit
fi

official_updates=$(checkupdates 2>/dev/null | wc -l)

aur_updates=$($AUR_HELPER -Qua 2>/dev/null | wc -l)

total_updates=$((official_updates + aur_updates))

if [ "$total_updates" -eq 0 ]; then
    printf '{"text": "0", "tooltip": "System is up to date", "class": "green"}'
    exit
fi

css_class="green"
if [ "$total_updates" -gt "$THRESHHOLD_YELLOW" ]; then
    css_class="yellow"
fi
if [ "$total_updates" -gt "$THRESHHOLD_RED" ]; then
    css_class="red"
fi 

tooltip="$total_updates Total Updates\nOfficial: $official_updates\nAUR:      $aur_updates\nClick to update"

printf '{"text": "%s", "tooltip": "%s", "class": "%s"}' "$total_updates" "$tooltip" "$css_class"
