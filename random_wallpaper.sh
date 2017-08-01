#!/bin/bash
#crontab: */2 * * * *  DISPLAY=:0.0 "$conf/random_wallpaper.sh" &

conf="$HOME/.config/i3"
dir="$HOME/Pictures/Wallpapers"
disps=(DVI-I-1 DVI-I-2)

find "$dir" -type f | shuf -n ${#disps[@]} | tee "$conf/.current_wallpaper" | xargs feh -rz --bg-fill
