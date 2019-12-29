#!/usr/bin/env bash
# Move container and focus to a relative workspace

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

rel=$1
move=$2
cws="$($conf/scripts/current_workspace.sh)"
ws="number $(expr $cws + $rel)"
if [ "$move" == "true" ]; then
  i3-msg -t command "mark _focus; move container to workspace $ws; [con_mark=\"_focus\"] focus; unmark _focus"
else
  i3-msg -t command "workspace $ws"
fi
