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

# Script to manage screenshot utility

prompt='Screenshot'
mesg="DIR: ~/Pictures"

# screenshot config
source ~/.config/ml4w/settings/screenshot-filename.sh 2>/dev/null || NAME="screenshot_$(date +%d%m%Y_%H%M%S).jpg"
source ~/.config/ml4w/settings/screenshot-folder.sh 2>/dev/null || screenshot_folder="$HOME/Pictures/Screenshots/"
export GRIMBLAST_EDITOR="$(echo 'pinta')"

# screenshot launcher
rofi_cmd() {
    rofi -dmenu -replace \
        -config ~/.config/rofi/screenshot.rasi \
        -i -no-show-icons \
        -p "$1" \
        -mesg "$2"
}

# function to take full mode 
take_instant_full() {
    grim "$NAME" && notify-send -u low "Screenshot" "Full screen saved to $screenshot_folder/$NAME" -i camera-photo
    [[ -f "$HOME/$NAME" && -d "$screenshot_folder" && -w "$screenshot_folder" ]] && mv "$HOME/$NAME" "$screenshot_folder/"
}

# function to take area
take_instant_area() {
    local pid_picker region
    
    # freeze selected area
    hyprpicker -r -z &
    pid_picker=$!
    trap 'kill "$pid_picker" 2>/dev/null' EXIT
    sleep 0.1
    
    region=$(slurp -b "#00000080" -c "#d7bafbff" -w 2) || exit 0
    [[ -z "$region" ]] && exit 0
    
    # unfreeze screen
    kill "$pid_picker" 2>/dev/null
    trap - EXIT
    
    # capture and notify
    grim -g "$region" "$NAME" && notify-send -u low "Screenshot" "Area selection saved to $screenshot_folder/$NAME" -i camera-photo
    [[ -f "$HOME/$NAME" && -d "$screenshot_folder" && -w "$screenshot_folder" ]] && mv "$HOME/$NAME" "$screenshot_folder/"
}

if [[ "$1" == "--instant" ]]; then
    take_instant_full
    exit 0
elif [[ "$1" == "--instant-area" ]]; then
    take_instant_area
    exit 0
fi

# menu options
option_immediate="Immediate"
option_delayed="Delayed"

option_capture_full="Capture Everything"
option_capture_display="Capture Active Display"  
option_capture_area="Capture Selection"

option_timer_5="5 seconds"
option_timer_10="10 seconds"
option_timer_20="20 seconds"
option_timer_30="30 seconds"
option_timer_60="1 minute"

action_copy="Copy to Clipboard"
action_save="Save to File"
action_copy_save="Copy & Save"
action_edit="Edit in Pinta"

# main menu
main_menu() {
    echo -e "$option_immediate\n$option_delayed" | rofi_cmd "Screenshot Mode" "Choose immediate or delayed capture"
}

# timer selection
timer_menu() {
    echo -e "$option_timer_5\n$option_timer_10\n$option_timer_20\n$option_timer_30\n$option_timer_60" | \
        rofi_cmd "Timer" "Select delay before capture"
}

# capture type selection  
capture_menu() {
    echo -e "$option_capture_full\n$option_capture_display\n$option_capture_area" | \
        rofi_cmd "Capture Type" "Select what to capture"
}

# action selection
action_menu() {
    echo -e "$action_save\n$action_copy\n$action_copy_save\n$action_edit" | \
        rofi_cmd "Action" "Choose what to do with screenshot"
}

# timer countdown
countdown_timer() {
    local timer=$1
    
    if [[ $timer -gt 10 ]]; then
        notify-send -u low "Screenshot Timer" "Taking screenshot in ${timer} seconds" -i camera-photo
        countdown_remaining=$((timer - 10))
        sleep $countdown_remaining
        timer=10
    fi
    
    while [[ $timer -gt 0 ]]; do
        if [[ $timer -le 5 ]]; then
            notify-send -u normal "Screenshot Timer" "${timer}..." -i camera-photo -t 800
        elif [[ $timer -eq 10 ]]; then
            notify-send -u low "Screenshot Timer" "Taking screenshot in ${timer} seconds" -i camera-photo
        fi
        timer=$((timer - 1))
        sleep 1
    done
    
    notify-send -u low "Screenshot Timer" "Capturing now!" -i camera-photo -t 500
}

# function to execute screenshot capture
take_screenshot() {
    local action_type="$1"
    local capture_type="$2"
    local use_timer="$3"
    local timer_duration="$4"
    
    # Apply timer if needed
    if [[ "$use_timer" == "true" ]]; then
        countdown_timer "$timer_duration"
    fi
    
    sleep 0.5
    
    # execute grimblast command
    case "$action_type" in
        "copy")
            grimblast --notify copy "$capture_type"
            notify-send -u low "Screenshot" "📋 Copied to clipboard" -i edit-copy
            ;;
        "save")
            grimblast --notify save "$capture_type" "$NAME"
            move_to_folder
            notify-send -u low "Screenshot" "💾 Saved to $screenshot_folder/$NAME" -i document-save
            ;;
        "copysave")
            grimblast --notify copysave "$capture_type" "$NAME"
            move_to_folder
            notify-send -u low "Screenshot" "📋💾 Copied and saved to $screenshot_folder/$NAME" -i camera-photo
            ;;
        "edit")
            grimblast --notify save "$capture_type" "$NAME"
            move_to_folder
            "$GRIMBLAST_EDITOR" "$screenshot_folder/$NAME" &
            notify-send -u low "Screenshot" "🎨 Opening in editor" -i applications-graphics
            ;;
    esac
}

# move screenshot to designated folder
move_to_folder() {
    if [[ -f "$HOME/$NAME" && -d "$screenshot_folder" && -w "$screenshot_folder" ]]; then
        mv "$HOME/$NAME" "$screenshot_folder/"
    fi
}

# parse timer selection
parse_timer() {
    case "$1" in
        "$option_timer_5") echo "5" ;;
        "$option_timer_10") echo "10" ;;
        "$option_timer_20") echo "20" ;;
        "$option_timer_30") echo "30" ;;
        "$option_timer_60") echo "60" ;;
        *) echo "0" ;;
    esac
}

# parse capture type
parse_capture_type() {
    case "$1" in
        "$option_capture_full") echo "screen" ;;
        "$option_capture_display") echo "output" ;;
        "$option_capture_area") echo "area" ;;
        *) echo "screen" ;;
    esac
}

# parse action type
parse_action_type() {
    case "$1" in
        "$action_save") echo "save" ;;
        "$action_copy") echo "copy" ;;
        "$action_copy_save") echo "copysave" ;;
        "$action_edit") echo "edit" ;;
        *) echo "save" ;;
    esac
}

# main execution flow
main() {
    chosen_mode=$(main_menu)
    [[ -z "$chosen_mode" ]] && exit 0
    
    local use_timer="false"
    local timer_duration="0"
    
    if [[ "$chosen_mode" == "$option_delayed" ]]; then
        chosen_timer=$(timer_menu)
        [[ -z "$chosen_timer" ]] && exit 0
        timer_duration=$(parse_timer "$chosen_timer")
        use_timer="true"
    fi
    
    chosen_capture=$(capture_menu)
    [[ -z "$chosen_capture" ]] && exit 0
    capture_type=$(parse_capture_type "$chosen_capture")
    
    chosen_action=$(action_menu)
    [[ -z "$chosen_action" ]] && exit 0
    action_type=$(parse_action_type "$chosen_action")
    
    take_screenshot "$action_type" "$capture_type" "$use_timer" "$timer_duration"
}

# help function
show_help() {
    echo "Material You Screenshot Tool"
    echo "============================"
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  (none)         Interactive menu mode"
    echo "  --instant      Take full screen immediately"
    echo "  --instant-area Take area selection immediately"
    echo "  -h, --help     Show this help"
    echo ""
    echo "Features:"
    echo "  • Material You themed interface"
    echo "  • Multiple capture modes (full/display/area)"
    echo "  • Timer delays (5s to 60s)"
    echo "  • Multiple actions (copy/save/edit)"
    echo "  • Integration with Pinta editor"
    echo ""
    echo "Dependencies: grimblast, grim, slurp, rofi, wl-copy, notify-send"
}

# handle command line arguments
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    --instant)
        take_instant_full
        exit 0
        ;;
    --instant-area)
        take_instant_area
        exit 0
        ;;
    "")
        main
        ;;
    *)
        echo "Invalid option: $1"
        echo "Use '$0 --help' for usage information"
        exit 1
        ;;
esac
