#!/bin/bash
# Simple Yad Frontend to set PipeWire metadata
# (Based on AVLinux PipeWire Tools)
#
# This version shows a read-only "Current Latency" field calculated as:
#    latency = (Quantum / Sample Rate) * 1000  [ms]
#
# When you click Apply, the new settings are saved via pw-metadata and a success
# message is displayed in the main window. The Restart buttons restart PipeWire
# and Wireplumber with an update message.
#
# The window is re-displayed (in a loop) so that the user always sees updated values.
#
# Dependencies: yad, bc, pw-metadata, systemctl (user mode)

# Function to calculate latency (in ms)
calculate_latency() {
    local quantum=$1
    local rate=$2
    # Use bc with -l to force floating point arithmetic,
    # then format the result to 2 decimal places.
    echo "($quantum / $rate) * 1000" | bc -l | awk '{printf "%.2f", $0}'
}

# Function to restart PipeWire
restart_pipewire() {
    systemctl restart --user pipewire.service
    main_message+="\nPipeWire restarted successfully!"
}

# Function to restart Wireplumber
restart_wireplumber() {
    systemctl restart --user wireplumber.service
    main_message+="\nWirePlumber restarted successfully!"
}

# Initialize status message (shown above the form)
main_message=""

while true; do
    # Get current quantum and sample rate from PipeWire metadata
    current_quantum=$(pw-metadata -n settings | awk -F"'" '/clock.force-quantum/ {print $4}')
    current_rate=$(pw-metadata -n settings | awk -F"'" '/clock.force-rate/ {print $4}')

    # If the forced values are empty, assume defaults (1024/48000)
    current_quantum=${current_quantum:-1024}
    current_rate=${current_rate:-48000}

    # Additionally, if the retrieved values are 0, then force defaults.
    if [ "$current_quantum" -eq 0 ]; then
        current_quantum=1024
    fi
    if [ "$current_rate" -eq 0 ]; then
        current_rate=48000
    fi

    # Calculate latency: (quantum / sample rate * 1000)
    current_latency=$(calculate_latency "$current_quantum" "$current_rate")

    # If no status message is set, use the default instructions.
    if [ -z "$main_message" ]; then
        main_message="<b>Select Quantum (buffer size) and Sample Rate.</b>"
    fi

    # Display Yad form with three fields and four buttons.
    output=$(yad \
        --form --columns=2 \
        --field="Quantum (bytes):CB" "$current_quantum"!32!48!64!128!256!512!1024!2048 \
        --field="Samples/sec.:CB" "$current_rate"!44100!48000!88200!96000 \
        --field="Latency (ms):RO" "$current_latency" \
        --button="Restart Pipewire:10" \
        --button="Restart Wireplumber:11" \
        --button="Close:1" \
        --button="Apply:0" \
        --align=left \
        --height=180 \
        --width=480 \
        --center \
        --title="Set PipeWire Metadata" \
        --window-icon=preferences \
        --text "$main_message" \
        --text-align=center)

    # Capture Yad exit code
    exit_status=$?

    # If the window is closed (or output is empty) or if Close was pressed, exit.
    if [ -z "$output" ] || [ "$exit_status" -eq 1 ]; then
        exit 0
    fi

    # Split the Yad form output into an array (fields are separated by "|")
    IFS='|' read -ra settings <<< "$output"

    # Process the selected action (Restart or Apply)
    case $exit_status in
        10)
            restart_pipewire
            ;;
        11)
            restart_wireplumber
            ;;
        0)
            pw-metadata -n settings 0 clock.force-quantum "${settings[0]}"
            pw-metadata -n settings 0 clock.force-rate "${settings[1]}"
            main_message="<b>Settings applied successfully!</b>"
            ;;
    esac
    # Loop repeats and displays updated values and the status message.
    main_message="" #clear message after each iteration
done

exit 0
