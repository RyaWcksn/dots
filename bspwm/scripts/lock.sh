#!/bin/bash
# Get the current wallpaper using feh (or the method you use to set wallpapers)
wallpaper=$(feh --bg-fill --no-fehbg --randomize --quiet --bg-center)

# Take a screenshot
scrot /tmp/lockscreen.png

# Apply a blur filter to the screenshot
convert /tmp/lockscreen.png -blur 0x6 /tmp/lockscreen.png

# Lock the screen with i3lock using the blurred screenshot
i3lock -i /tmp/lockscreen.png

# Clean up the temporary screenshot
rm /tmp/lockscreen.png
