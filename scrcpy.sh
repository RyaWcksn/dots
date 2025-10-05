#!/bin/bash

function scr ()
{
flag="$1"
app="$2"

case "$flag" in
    --app)
	    if [[ -n "$app" ]]; then
		    scrcpy --shortcut-mod=lctrl -b 1M --max-fps=60 -K --new-display --start-app="+?$app"
	    else
		    PKG=$(adb shell 'pm list packages' | sed 's/.*://g' | fzf)
		    [ -z "$PKG" ] && echo "No app selected"
		    scrcpy --shortcut-mod=lctrl -b 1M --max-fps=60 -K --new-display --start-app="$PKG"
	    fi
        ;;
    --sound)
	scrcpy --shortcut-mod=lctrl --audio-codec=flac --audio-bit-rate=64K -b 1M --audio-buffer=125 --no-video
        ;;

    --wireless)
        # Check if a device is already connected via Wi-Fi and is authorized
        if adb devices | grep -E "\b[0-9]{1,3}(\.[0-9]{1,3}){3}:5555\b" | grep -q "device"; then
            echo "[✓] Wi-Fi device already connected and authorized."
        else
            echo "[*] No authorized Wi-Fi device found. Attempting to connect..."

            echo "[*] Switching device to TCP/IP mode on port 5555..."
            adb tcpip 5555
	    sleep 2

            echo "[*] Getting device IP address..."

            # Determine local subnet prefix (e.g., 192.168.1)
            LOCAL_SUBNET=$(ip route get 1 | awk '/src/ {print $7}' | cut -d. -f1-3)

	    echo "local subnet = $LOCAL_SUBNET "

            # Get matching IP from Android device
	    IP=$(adb shell ip addr show | grep 'inet ' | awk '{print $2}' | while read ip; do
                ip_clean=$(echo "$ip" | cut -d/ -f1)
                subnet_prefix=$(echo "$ip_clean" | cut -d. -f1-3)
                if [[ "$subnet_prefix" == "$LOCAL_SUBNET" ]]; then
                    echo "$ip_clean"
                    break
                fi
            done)

            echo "[*] Got IP address $IP"

            if [[ -z "$IP" ]]; then
                echo "[!] Failed to get IP address of device. Is Wi-Fi enabled?"
                return 1
            fi

            echo "[*] Found IP: $IP"
            echo "[*] You can now disconnect the USB cable."

            echo "[*] Connecting to $IP:5555..."
            adb connect "$IP:5555"

            sleep 1

            echo "[*] Checking device authorization status..."
            STATE=$(adb devices | grep "$IP" | awk '{print $2}')

            if [[ "$STATE" != "device" ]]; then
                echo "[!] Device not authorized or offline. Please check authorization prompt on your phone and try again."
                return 1
            fi

            echo "[✓] Device authorized."
        fi

        echo "[*] Launching scrcpy..."
		scrcpy -s $(adb devices | grep 5555 | awk '{print $1}' | cut -d: -f1):5555 --shortcut-mod=lctrl --audio-bit-rate=64K --audio-buffer=20 -b 1M --max-size=800 --max-fps=45 -K
        ;;


    --mic)
        local LATENCY=20
        local PIPE_FILE="/tmp/scrcpy_audio.raw"
        local SOURCE_NAME="ScrcpyMic"
        local MODULE_ID

        # This function will be called when the script exits.
        function cleanup() {
            echo -e "\n[*] Cleaning up..."
            if [[ -n "$PAREC_PID" ]]; then
                echo "[*] Stopping dummy recording process..."
                kill "$PAREC_PID" 2>/dev/null
            fi
            if [[ -n "$MODULE_ID" ]]; then
                echo "[*] Unloading PulseAudio module $MODULE_ID..."
                pactl unload-module "$MODULE_ID"
            fi
            if [ -p "$PIPE_FILE" ]; then
                rm "$PIPE_FILE"
            fi
            # Remove the traps to avoid multiple executions.
            trap - INT TERM EXIT
        }

        # Trap signals to run the cleanup function upon exit or interruption.
        trap cleanup INT TERM EXIT

        # Create the pipe if it doesn't exist
        [ -p "$PIPE_FILE" ] || mkfifo "$PIPE_FILE"

        echo "[*] Creating virtual microphone '$SOURCE_NAME'..."
        MODULE_ID=$(pactl load-module module-pipe-source source_name="$SOURCE_NAME" file="$PIPE_FILE" channels=2 format=s16le rate=48000)

        # Check if module loaded successfully
        if ! [[ "$MODULE_ID" =~ ^[0-9]+$ ]]; then
            echo "[!] Failed to load PulseAudio module. Make sure PulseAudio is running."
            return 1
        fi

        echo "[✓] Virtual microphone created. You can now select it in other apps."
        echo "[*] Starting scrcpy audio capture. Press Ctrl+C to stop."

	scrcpy --no-video --no-window --no-playback --audio-source=mic --audio-codec=raw --record-format=wav --record=/tmp/scrcpy_pipe --audio-buffer=$LATENCY --audio-output-buffer=10 
        ;;

    *)
        scrcpy --shortcut-mod=lctrl --audio-bit-rate=64K --audio-buffer=20 -b 1M --max-size=800 --max-fps=45 -K
        ;;
esac
}

screen() {
    if adb devices | grep -q "5555"; then
        scr --wireless
    else
        scr
    fi
}

screen
