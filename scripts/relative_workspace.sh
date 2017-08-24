#!/bin/bash
# Move container and focus to a relative workspace

conf=$(cd $(dirname $0)/.. ; pwd -P)
rel=$1
cws="$($conf/scripts/current_workspace.sh)"
ws=$(expr $cws + $rel)
i3-msg -t command "move container to workspace $ws; workspace $ws"
