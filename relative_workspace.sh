#!/bin/bash
# Move container and focus to a relative workspace

conf=/home/u8sand/.config/i3
rel=$1
cws=$("$conf/current_workspace.sh")
ws=$(expr $cws + $rel)
i3-msg -t command "move container to workspace $ws; workspace $ws"
