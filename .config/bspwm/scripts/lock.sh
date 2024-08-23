#!/bin/bash

# Path to the wallpaper image
wallpaper=$HOME/.config/bspwm/assets/fuyuko2.jpg

# Create a temporary directory to store the combined wallpaper
mkdir -p /tmp/lockscreen

# Get the resolution of all connected monitors and combine wallpapers
screens=$(xrandr --query | grep ' connected' | awk '{print $3}' | grep -oP '\d+x\d+\+\d+\+\d+')
final_wallpaper="/tmp/lockscreen/lockscreen_combined.png"

monitors=$(xrandr --listactivemonitors | grep -oP '\d+: \+\*\d+ \+\K[\d,x+]+')

# Parse the resolutions and positions
IFS=$'\n' read -r -d '' -a monitor_data <<< "$monitors"

# Determine which monitor is on the left and which is on the right
if [[ ${monitor_data[0]} == *"+0+0"* ]]; then
  left_monitor="${monitor_data[0]}"
  right_monitor="${monitor_data[1]}"
else
  left_monitor="${monitor_data[1]}"
  right_monitor="${monitor_data[0]}"
fi

# Extract resolutions (before the '+' character)
left_resolution=$(echo $left_monitor | grep -oP '^\d+x\d+')
right_resolution=$(echo $right_monitor | grep -oP '^\d+x\d+')

# Resize the images to match the monitor resolutions
convert $HOME/.config/bspwm/assets/fuyuko2.jpg -resize $left_resolution! left_resized.png
convert $HOME/.config/bspwm/assets/fuyuko2.jpg -resize $right_resolution! right_resized.png

# Combine the resized images side by side
convert left_resized.png right_resized.png +append $final_wallpaper

echo "Combined image created as combined_output.png"

# Apply a blur filter to the combined wallpaper
convert $final_wallpaper -blur 0x6 $final_wallpaper

# Lock the screen with i3lock using the combined blurred wallpaper
i3lock -i $final_wallpaper

# Clean up the temporary files
rm -r /tmp/lockscreen
