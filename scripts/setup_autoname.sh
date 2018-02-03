#!/usr/bin/env bash

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

python3 "$conf/scripts/autoname_workspaces.py" \
  || i3-nagbar -t error -m "Couldn't start autoname_workspaces"
