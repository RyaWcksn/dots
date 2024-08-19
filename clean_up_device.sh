#!/bin/bash

# List of directories to clear
directories=("Clones" "Orgs" "hardir" "redis_data" "ryawcksn.vercel.app" ".emacs.d" "Sandbox" "Downloads" "Pictures" "Videos") #"Personal" "Sandbox" "Work" "dots" "Downloads" "Picture" "Musics" "Videos")

# Number of overwrite passes
overwrite_passes=3

# Iterate over each directory
for dir in "${directories[@]}"; do
  # Check if the directory exists
  if [ -d "$HOME/$dir" ]; then
    # Shred all files in the directory with sudo
    sudo find "$HOME/$dir" -type f -exec shred -u -n $overwrite_passes {} \;
    # Remove all directories and subdirectories with sudo
    sudo find "$HOME/$dir" -type d -exec rm -rf {} + 2>/dev/null
    echo "Cleared and shredded files and removed subdirectories in $dir"
  else
    echo "Directory $dir does not exist"
  fi
done
