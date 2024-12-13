#!/bin/bash

# Run iwgetid to get the SSID
ssid=$(iwgetid -r)

# Check if SSID is empty
if [ -z "$ssid" ]; then
    echo "[ 無し ]"
else
    echo "[ $ssid ]"
fi

