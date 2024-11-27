#!/usr/bin/env bash

dunstctl set-paused true
i3lock -k --ignore-empty-password -f -c 3e4f75 --insidever-color=6666FFAA --insidewrong-color=FF333322 --inside-color=333333EE --time-pos="ix:iy + 300" --time-color=FFFFFFDD --time-font="Iosevka Extended" --time-size=40 --date-str="%F" --date-color=FFFFFFAA --date-font="Iosevka Extended" --date-size=25 --redraw-thread
dunstctl set-paused false
