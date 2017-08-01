#!/bin/bash
# Get current focused workspace

conf="$HOME/.config/i3"
i3-msg -t get_workspaces | python -c "
import sys, json
print([d['num']
       for d in json.load(sys.stdin)
       if d['focused']][0])"
