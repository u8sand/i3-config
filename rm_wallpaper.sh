#!/bin/bash

conf="$HOME/.config/i3"
disps=(DVI-I-2 DVI-I-3)
disp="$($conf/current_display.sh)"

let i=1
for d in ${disps[@]}; do
  if [ "$d" == "$disp" ]; then
    sed -n "${i}p" "$conf/.current_wallpaper" | xargs trash
    exit $(bash -c "$conf/random_wallpaper.sh")
  else
    let i="$i+1"
  fi
done
exit -1
