#!/usr/bin/env bash
# Get current focused workspace

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true) | .name'
