#!/bin/bash
xrandr --output VIRTUAL1 --off
xrandr --delmode VIRTUAL1 "android-virtual"
xrandr --rmmode "android-virtual"
