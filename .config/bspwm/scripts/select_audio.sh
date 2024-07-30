#!/bin/bash

theme="$HOME/.config/rofi/spotlight-audio.rasi"

list_audio_devices() {
    local type=$1
    pactl list short "$type" | while read -r line; do
        device=$(echo "$line" | awk '{print $2}')
        description=$(pactl list "$type" | grep -A 20 -E "Name:.*$device" | grep "Description:" | sed 's/^[ \t]*Description: //')
        echo "$description - $device"
    done
}

# Function to select an audio device
select_audio_device() {
    local type=$1
    local action=$2
    local device_list=$(list_audio_devices "$type")
    
    if [[ -z "$device_list" ]]; then
        echo "No $type devices found."
        exit 1
    fi

    local selected_device=$(echo "$device_list" | rofi -dmenu -theme "$theme" -p "Select $type device" -format 's')

    if [[ -z "$selected_device" ]]; then
        echo "No device selected."
	notify-send "No Device Selected" -i $HOME/.config/bspwm/assets/crop_fuyuko.jpg -t 8001
        exit 1
    fi

    local device_id=$(echo "$selected_device" | awk -F ' - ' '{print $NF}')
    
    echo "Setting default $type to $device_id"  # Debug information
    pactl "$action" "$device_id"
}

# Select audio input device
select_audio_input() {
    select_audio_device "sources" "set-default-source"
}

# Select audio output device
select_audio_output() {
    select_audio_device "sinks" "set-default-sink"
}

# Main menu
choice=$(echo -e "1. Select Audio Input\n2. Select Audio Output" | rofi -dmenu -theme "$theme" -p "Audio Selection" -format 'i' -lines 2)

case "$choice" in
    0)
        select_audio_input
        ;;
    1)
        select_audio_output
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac


