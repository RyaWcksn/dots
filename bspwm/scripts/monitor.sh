#!/bin/bash
xrandr --newmode "android-virtual"  74.48  1280 1336 1472 1664  720 721 724 746  -HSync +Vsync
xrandr --addmode VIRTUAL1 android-virtual
#xrandr --output VIRTUAL1 --left-of LVDS1 --mode android-virtual
xrandr --output VIRTUAL1 --above LVDS1 --mode android-virtual
