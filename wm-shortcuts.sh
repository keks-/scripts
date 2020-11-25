/usr/bin/env bash

grep '^bindsym' ~/.config/i3/config | sed 's/bindsym //' | rofi -i -dmenu
