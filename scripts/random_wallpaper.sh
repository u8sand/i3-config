#!/bin/bash
#crontab: */2 * * * *  DISPLAY=:0.0 "$conf/scripts/random_wallpaper.sh" &

conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/wallpaper.sh"

find "$dir" -type f | shuf -n ${#disps[@]} | tee "$save_current" | xargs feh -rz --bg-fill
