#!/usr/bin/env bash

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"
source "$conf/settings/wallpaper.sh"
disp="$($conf/scripts/current_display.sh)"

let i=1
for d in ${disps[@]}; do
  if [ "$d" == "$disp" ]; then
    sed -n "${i}p" "$save_current" | xargs trash
    exit $(bash -c "$conf/scripts/random_wallpaper.sh")
  else
    let i="$i+1"
  fi
done
exit -1
