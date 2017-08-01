#!/bin/bash
# Get current focused display

conf="$HOME/.config/i3"
cw=$($conf/current_workspace.sh)
i3-msg -t get_outputs | python -c "
import sys, json
print([d['name']
       for d in json.load(sys.stdin)
       if d['current_workspace']=='$cw'][0])"
