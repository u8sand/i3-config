#!/usr/bin/env bash
# Get current focused display

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

export cw=$($conf/scripts/current_workspace.sh)

i3-msg -t get_outputs | jq -r ".[] | select(.current_workspace == \"${cw}\") | .name"
