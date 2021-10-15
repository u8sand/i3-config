#!/usr/bin/env bash
# To enable, add `settings/systemd/random-wallpaper.*` to ~/.config/systemd/user/

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"
source "$conf/settings/wallpaper.sh"

find "$dir" -type f | shuf -n ${#disps[@]} | tee "$save_current" | xargs feh -rz --bg-fill
