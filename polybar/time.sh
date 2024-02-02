#!/bin/bash

# Get the current day of the week (0-6, where 0 is Sunday)
current_day=$(date +%u)

# Define an array with the Japanese day names
japanese_days=("日" "月" "火" "水" "木" "金" "土", "日")

# Get the Japanese day name
japanese_day=${japanese_days[current_day]}

echo $japanese_day
