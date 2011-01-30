#!/bin/sh

# outputs vital infos to show in the dwm statusbar 
# special treatment for notebooks 
# temp is done via lm_sensors due to compatibility
# TODO: cleanup, more elegant style to determine Master channels
#       add colors via statuscolors patch

dat() {
    dat=$(date '+%a %d.%m.%y - %H:%M')
    echo -e "$dat"
}

vol() {
    mixer=$(amixer info | awk '/Realtek\ ALC888.*/ { print }')
    if [ -z "$mixer" ]; then
        volume=$(amixer get Master | sed -n 's/ Front Right: Playback [0-9]\+ \[\([0-9%]\+\)\].*/\1/p')
    else
        volume=$(amixer get Master | sed -n 's/ Mono: Playback [0-9]\+ \[\([0-9%]\+\)\].*/\1/p')
    fi
    echo -e "$volume"
}

temp() {
    CORES=0
    for i in `sensors | awk '/Core\ [0-9]*/ { print $3 }' | cut -c '2-3'`; do
        SUM=$(($SUM + $i))
        CORES=$(($CORES + 1))
    done
    avg_temp=$(($SUM/$CORES))
    echo -e "$avg_temp"
}

battery() {
    #batt=$(acpi -b | awk '{ print $3, $4 }' | tr -d ',')
    INPUT=$(acpi -b)
    STRING=$(echo $INPUT | sed -e 's/\(^ *[^ ]*\) \([^ ]*\) \([A-Z][a-z]*\), \([0-9]*%\).*$/\3 \4/')
    FIRST=$(echo $STRING | cut -c 1)
      
    if [ "$FIRST" = "F" ]; then
        STRING=$(echo $STRING | sed -e 's/\(^ *[^ ]*\) \([^ ]*\)$/\\:D\/ \2/')
    elif [ "$FIRST" = "D" ]; then
        STRING=$(echo $STRING | sed -e 's/\(^ *[^ ]*\) \([^ ]*\)$/:E \2/')
    elif [ "$FIRST" = "C" ]; then
        STRING=$(echo $STRING | sed -e 's/\(^ *[^ ]*\) \([^ ]*\)$/:> \2/')
    else 
        STRING=$(echo $STRING | sed -e 's/\(^ *[^ ]*\) \([^ ]*\)$/:o \2/')
    fi
    echo -e "$STRING"
}

# piping done here(?!)
if [ -e "/proc/acpi/battery/" ]; then
    xsetroot -name "$(battery) | $(temp)°C | vol $(vol) | $(dat)"
else
    xsetroot -name "$(temp)°C | vol $(vol) | $(dat)"
fi

exit
