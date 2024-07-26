#!/bin/bash

# Take a screenshot
cp $HOME/.config/bspwm/assets/fuyuko2.jpg /tmp/lockscreen.png

# Apply a blur filter to the screenshot
convert /tmp/lockscreen.png -blur 0x6 /tmp/lockscreen.png

# Lock the screen with i3lock using the blurred screenshot
i3lock -i /tmp/lockscreen.png

# Clean up the temporary screenshot
rm /tmp/lockscreen.png
