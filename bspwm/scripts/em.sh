#!/bin/bash

# Check if Emacs daemon is already running
if emacsclient -e "(+ 1 1)" 2>/dev/null; then
  notify-send "Emacs" "Emacs daemon already started" --icon=$HOME/.config/bspwm/assets/greeting.png --expire-time=4000
else
  # If not running, start the Emacs daemon
  echo "Starting Emacs daemon..."
  emacs --daemon
  notify-send "Emacs" "Emacs daemon started" --icon=$HOME/.config/bspwm/assets/greeting.png --expire-time=4000
fi

