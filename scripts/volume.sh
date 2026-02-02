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
# Script to control volume 
#
# by yosmisyael (2024)

TAG="sys-notify"

get_vol() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'
}

is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"
}

is_mic_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"
}

case "$1" in
    up)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    mic_mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        if is_mic_muted; then
            notify-send -h string:x-canonical-private-synchronous:$TAG -i microphone-sensitivity-muted "Microphone" "Muted" -t 800
        else
            notify-send -h string:x-canonical-private-synchronous:$TAG -i microphone-sensitivity-high "Microphone" "Active" -t 800
        fi
        exit 0
        ;;
esac

raw_vol=$(get_vol)

vol_int=$(echo "$raw_vol" | awk '{printf("%d\n",$1*100)}')

if is_muted; then
    icon="audio-volume-muted"
    text="Muted"
else
    if [ "$vol_int" -lt 33 ]; then
        icon="audio-volume-low"
    elif [ "$vol_int" -lt 66 ]; then
        icon="audio-volume-medium"
    else
        icon="audio-volume-high"
    fi
    text="${vol_int}%"
fi

notify-send \
    -h string:x-canonical-private-synchronous:$TAG \
    -h int:value:"$vol_int" \
    -i "$icon" \
    "Volume: $text" \
    -t 800

