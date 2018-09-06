#!/usr/bin/env bash

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

n=$1
i3-msg "workspace $n; append_layout $conf/settings/layout-$n.json"
awk -F'"' '/name/{print $4" &"}' "$conf/settings/layout-$n.json" | bash -

