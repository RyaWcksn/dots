#!/bin/bash

wl(){
	local ssid
	local conn
	local selected_interface
	
	nmcli device wifi rescan > /dev/null
	ssid=$(nmcli -f SSID device wifi list | rofi -dmenu -p "Select WiFi network:" -theme $HOME/.config/rofi/spotlight-wifi.rasi)
	if [[ -z "$ssid" ]]; then
		notify-send "No Device Selected" -i $HOME/.config/bspwm/assets/crop_fuyuko.jpg -t 8001
		echo "Exiting"
		return
	fi
	echo "Selected SSID : $ssid"
	found=$(nmcli connection show | awk 'NR>1 {print $1}' | grep $ssid)
	echo "Found connection : $found"
	wifi_interfaces=$(iwconfig 2>/dev/null | awk '/^[[:alnum:]]/ {print $1}') 
	if [ -n "$wifi_interfaces" ]; then
	    selected_interface=$(echo "$wifi_interfaces" | rofi -dmenu -p "Select an interface:" -theme $HOME/.config/rofi/spotlight-wifi.rasi)
	    if [ -n "$selected_interface" ]; then
	        echo "Selected Wi-Fi interface: $selected_interface"
	        # You can add your actions here, e.g., connecting to a network using nmcli.
	    else
		notify-send "No Wifi interface Selected" -i $HOME/.config/bspwm/assets/crop_fuyuko.jpg -t 8001
	        echo "No Wi-Fi interface selected. Exiting."
	    fi
	else
	    notify-send "No Wifi interface found" -i $HOME/.config/bspwm/assets/crop_fuyuko.jpg -t 8001
	    echo "No Wi-Fi interfaces found."
	fi

	if [[ -n "$found" ]]; then
		echo "Connecting to $ssid..."
		conn=$(nmcli connection up "$found" ifname "$selected_interface")
		success=$(echo $conn | grep "successfully activated")
		if [[ -z $success ]]; then
			notify-send "Wi-Fi" "$conn" --icon=$HOME/.config/bspwm/assets/wifi.png --expire-time=4000
			return
		fi
		notify-send "Wi-Fi" "Connected to $found, At $selected_interface" --icon=$HOME/.config/bspwm/assets/wifi.png --expire-time=4000
		return
	fi
	
	echo "New connection, enter the password : "
	password=$(rofi -dmenu -p "New connection, enther the password: " -font "DejaVu Sans Mono 8" -lines 1 -theme $HOME/.config/rofi/spotlight-password.rasi)
	conn=$(nmcli device wifi connect "$ssid" password "$password" ifname "$selected_interface")
	success=$(echo $conn | grep "successfully activated")
	if [[ -z $success ]]; then
		notify-send "Wi-Fi" "Cannot connect to $ssid, Issue $conn" --icon=$HOME/.config/bspwm/assets/wifi.png --expire-time=4000
		return
	fi
	notify-send "Wi-Fi" "Connected to $ssid, At $selected_interface" --icon=$HOME/.config/bspwm/assets/wifi.png --expire-time=4000
}

wl
