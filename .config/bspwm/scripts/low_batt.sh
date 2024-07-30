#!/bin/bash
alarm="$HOME/.config/bspwm/assets/gundam_warning.mp3"

# Notify when below this percentage
warning_level=15

# How often to check battery status, in minutes
check_interval=2

lock_file="/tmp/my_script.lock"

# Check if the lock file exists
if [ -e "$lock_file" ]; then
    echo "Script is already running."
    exit 1
else
    # Create the lock file
    touch "$lock_file"
fi


# Create a lock file to ensure the script runs only once per session
while true; do
  battery_level=$(acpi -b \
    | cut -d, -f2 | cut --characters=2,3,4 \
    | sed 's/%//g')
  charging=$(acpi -b | grep -c "Charging")

  # When battery is low, and not already charging
  if [ $battery_level -lt $warning_level ] &&
     [ $charging -eq 0 ]
  then
    play -q -v 0.40 "$alarm" &
    notify-send " Low battery: ${battery_level}% " \
      " $USER-sama $HOSTNAME's battery running low " -i $HOME/.config/bspwm/assets/battery.png -t 8001
  fi
  
  sleep ${check_interval}m
done


rm "$lock_file"
