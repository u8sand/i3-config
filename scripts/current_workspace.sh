#!/usr/bin/env bash
# Get current focused workspace

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

i3-msg -t get_workspaces | python3 -c "
import sys, json
print([d['num']
       for d in json.load(sys.stdin)
       if d['focused']][0])"
