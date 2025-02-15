#!/bin/bash

# Set wallpaper path
wallpaper="$HOME/.config/bspwm/assets/gazette.webp"
temp_dir="/tmp/lockscreen"
mkdir -p "$temp_dir"

# Get screen resolution
resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')  # Example: "1920x1080"

# Temporary resized and blurred wallpaper
resized_wallpaper="$temp_dir/lockscreen_resized.png"
blurred_wallpaper="$temp_dir/lockscreen_blur.png"

# Resize the wallpaper to match screen resolution
convert "$wallpaper" -resize "$resolution" "$resized_wallpaper"

# Apply a blur effect
convert "$resized_wallpaper" -blur 0x8 "$blurred_wallpaper"

# Lock the screen with the fullscreen blurred wallpaper
i3lock -i "$blurred_wallpaper"

# Cleanup temp files
rm -r "$temp_dir"
