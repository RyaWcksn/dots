#!/bin/bash

# Check if Wi-Fi is connected
if iwctl station wlp3s0 show | grep -q "connected"; then
    echo "Wi-Fi"
# Check if LAN is connected
elif ip link show enxeeccdcef41fe | grep -q "state UP"; then
    echo "LAN"
else
    echo "Disconnected"
fi
