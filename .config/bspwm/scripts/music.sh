#!/bin/bash

# Function to list and play music
play_music() {
    music_list=$(mpc listall | rofi -dmenu -p "Select a song:" -theme $HOME/.config/rofi/spotlight.rasi)

    echo "Picked : $music_list"

    if [[ -n "$music_list" ]]; then
        mpc clear
        mpc searchadd filename "$music_list"
        mpc play
    fi
}

# Main script
play_music
