#!/usr/bin/env bash
# Get current focused display

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

export cw=$($conf/scripts/current_workspace.sh)

i3-msg -t get_outputs | python3 -c "
import os, sys, json
print([d['name']
       for d in json.load(sys.stdin)
       if d['current_workspace']==os.environ['cw']][0])"
