#!/usr/bin/env bash
#crontab: */2 * * * *  DISPLAY=:0.0 "$conf/scripts/random_wallpaper.sh" &

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"
source "$conf/settings/wallpaper.sh"

find "$dir" -type f | shuf -n ${#disps[@]} | tee "$save_current" | xargs feh -rz --bg-fill
