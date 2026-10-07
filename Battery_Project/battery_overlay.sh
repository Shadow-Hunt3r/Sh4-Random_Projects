#!/bin/bash

FONT="-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1"
BAT="/sys/class/power_supply/BAT1"
CURRENT_COLOR=""
OSD_PID=""
declare -A OSDConfigs
OSDConfigs=(
    [Place]="top"  # Top, Middle or Bottom alignment on the screen
    [Align]="left" # Left, Middle or Right alignment on the screen
    [Offset]=5     # padding based on alignment
)

killall osd_cat 2>/dev/null

#MangoHud detection
# Returns 0 (true) if MangoHud overlay is currently active.
is_mangohud_active() {
    # Standalone overlay
    pgrep -x mangoapp >/dev/null 2>&1 && return 0

    # MangoHud loaded as a Vulkan layer inside any game/process
    for maps in /proc/[0-9]*/maps; do
        grep -q "MangoHud" "$maps" 2>/dev/null && return 0
    done

    return 1
}

#Colour switching for recognition if it was charging or not
get_color() {
    local status=""
    [ -r "$BAT/status" ] && read -r status < "$BAT/status"
    case "$status" in
        Charging|Full) echo "cyan3" ;;
        *)             echo "firebrick" ;;
    esac
}

#osd_cat lifecycle 2x function to stop and start it
stop_osd() {
    if [ -n "$OSD_PID" ]; then
        kill "$OSD_PID" 2>/dev/null
        wait "$OSD_PID" 2>/dev/null
    fi
    killall osd_cat 2>/dev/null
    OSD_PID=""
    CURRENT_COLOR=""
}

start_osd() {
    local color="$1"
    (
        while true; do
            [ -r "$BAT/capacity" ] && echo " B: $(< "$BAT/capacity")%"
            sleep 5
        done
    ) | osd_cat --lines=1 --delay=10 \
                --font="$FONT" \
                --color="$color" \
                --pos=${OSDConfigs["Place"]} --align=${OSDConfigs["Align"]} --offset=${OSDConfigs["Offset"]} &
    OSD_PID=$!
    CURRENT_COLOR="$color"
}

cleanup() {
    trap - EXIT INT TERM
    stop_osd
    exit 0
}

trap cleanup EXIT INT TERM
#Primary loop
while true; do
    if is_mangohud_active; then
        # Hide OSD while MangoHud is on screen
        [ -n "$OSD_PID" ] && stop_osd
        sleep 5
        continue
    fi

    color=$(get_color)

    # (Re)start only if nothing is running or the colour must change
    if [ "$color" != "$CURRENT_COLOR" ] || [ -z "$OSD_PID" ]; then
        stop_osd
        start_osd "$color"
    fi

    sleep 5
done
