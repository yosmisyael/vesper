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

# Script to manage clipboard 
# Usage: 
#     ./clipboard.sh [d|w|c] d = delete mode, w = wipe/clear all, c = copy mode (default)

CLIPBOARD_THEME="$HOME/.config/rofi/clipboard.rasi"
CONFIRM_THEME="$HOME/.config/rofi/confirm.rasi"

case $1 in
    d|delete)
        cliphist list | rofi -dmenu -replace \
            -config "$CLIPBOARD_THEME" \
            -p "Delete" \
            -mesg "Select clipboard item to <b>delete permanently</b>" \
            | cliphist delete
        
        if [ $? -eq 0 ]; then
            notify-send -u low "Clipboard" "Item deleted from history" -i edit-delete
        fi
        ;;
        
    w|wipe|clear)
        # Wipe entire clipboard history with confirmation
        selection=$(echo -e "Clear All\n󰜺Cancel" | rofi -dmenu \
            -config "$CONFIRM_THEME" \
            -p "Confirm" \
            -mesg "This will <b>permanently delete</b> all clipboard history")
        
        if [ "$selection" = "Clear All" ]; then
            cliphist wipe
            notify-send -u normal "Clipboard" "All clipboard history cleared" -i edit-clear-all
            echo "Clipboard history cleared"
        else
            echo "Operation cancelled"
        fi
        ;;
        
    c|copy|"")
        # Default mode - copy selected item to clipboard
        selected=$(cliphist list | rofi -dmenu -replace \
            -config "$CLIPBOARD_THEME" \
            -p "Clipboard" \
            -mesg "Select item to copy to clipboard")
        
        if [ -n "$selected" ]; then
            echo "$selected" | cliphist decode | wl-copy
            notify-send -u low "Clipboard" "Item copied to clipboard" -i edit-copy
            echo "Item copied to clipboard"
        fi
        ;;
        
    h|help|--help)
        echo "Vesper Clipboard Manager"
        echo "=============================="
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  (none)    Copy selected item to clipboard (default)"
        echo "  c, copy   Copy selected item to clipboard"
        echo "  d, delete Delete selected item from history"
        echo "  w, wipe   Clear all clipboard history"
        echo "  h, help   Show this help message"
        echo ""
        echo "Dependencies: cliphist, rofi, wl-copy, notify-send"
        ;;
        
    *)
        echo "Invalid option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
