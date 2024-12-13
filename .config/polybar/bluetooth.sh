#!/bin/bash

# Store the data in a variable or a file
data=$(bluetoothctl info)

# Extract the Name using grep and awk
name=$(echo "$data" | grep -oP '^(\t| )*Name: \K.*')

# Check if name is empty and set to "無し" if not found
if [[ -z "$name" ]]; then
    name="[ 無し ]"
fi

# Print the extracted name
echo "[ $name ]"
