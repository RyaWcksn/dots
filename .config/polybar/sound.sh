#!/bin/bash
volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)
if [ "$mute" = "true" ]; then
    echo "[ 無音 ]"
else
    echo "[ 音量:  $volume% ]"
fi
