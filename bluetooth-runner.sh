#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [start|shutdown]"
    exit 1
fi

action="$1"

case "$action" in
    start)
        echo "Starting bluetooth service..."
        sudo systemctl start bluetooth.service
        echo "Bluetooth service started."
        ;;
    shutdown)
        echo "Shutting down bluetooth service..."
        sudo systemctl stop bluetooth.service
        echo "Bluetooth service stopped."
        ;;
    *)
        echo "Invalid argument: $action"
        echo "Usage: $0 [start|shutdown]"
        exit 1
        ;;
esac

exit 0
