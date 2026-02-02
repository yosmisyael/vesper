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
# Script to manage system power
#
# by yosmisyael (2024)

terminate_clients() {
 	TIMEOUT=5
	client_pids=$(hyprctl clients -j | jq -r '.[] | .pid')

	for pid in $client_pids; do
		echo ":: Sending SIGTERM to PID $pid"
		kill -15 $pid
	done

	start_time=$(date +%s)
	for pid in $client_pids; do
		while kill -0 $pid 2>/dev/null; do
		current_time=$(date +%s)
		elapsed_time=$((current_time - start_time))

		if [ $elapsed_time -ge $TIMEOUT ]; then
			echo ":: Timeout reached."
			return 0
		fi

		echo ":: Waiting for PID $pid to terminate..."
		sleep 1
		done

		echo ":: PID $pid has terminated."
	done
}


if [[ -z "$1" ]]; then
    echo "Usage: $(basename "$0") [lock|exit|suspend|reboot|shutdown]"
    exit 1
fi

case "$1" in
    lock)
        pidof hyprlock || hyprlock
        ;;
    exit)
        terminate_clients && uwsm stop
        ;;
    suspend)
        loginctl lock-session 
        sleep 1
        systemctl suspend
        ;;
    hibernate)
        loginctl lock-session
        sleep 1
        systemctl hibernate
        ;;
    reboot)
        terminate_clients && systemctl reboot
        ;;
    shutdown)
        terminate_clients && shutdown -P 0
        ;;
    *)
        echo "Invalid command: $1"
        exit 1
        ;;
esac
