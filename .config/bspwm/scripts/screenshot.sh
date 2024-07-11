#!/bin/bash

case "$1" in
    "area")
        scrot -s --freeze 'Screenshot_%a-%d_%b_%y_%H.%M.png' -e 'mv $f ~/Pictures/Screenshots && sxiv -b ~/Pictures/Screenshots/$f && xclip -selection clipboard -target image/png -i ~/Pictures/Screenshots/$f && notify-send "Screenshot saved" "Name: $f" -i ~/Pictures/Screenshots/$f -t 5000'
        ;;
    "all")
        scrot 'Screenshot_%a-%d_%b_%y_%H.%M.png' -e 'mv $f ~/Pictures/Screenshots && sxiv -b ~/Pictures/Screenshots/$f && xclip -selection clipboard -target image/png -i ~/Pictures/Screenshots/$f && notify-send "Screenshot saved" "Name: $f" -i ~/Pictures/Screenshots/$f -t 5000'
        ;;
    "window")
        scrot -u 'Screenshot_%a-%d_%b_%y_%H.%M.png' -e 'mv $f ~/Pictures/Screenshots && sxiv -b ~/Pictures/Screenshots/$f && xclip -selection clipboard -target image/png -i ~/Pictures/Screenshots/$f && notify-send "Screenshot saved" "Name: $f" -i ~/Pictures/Screenshots/$f -t 5000'
        ;;
esac
