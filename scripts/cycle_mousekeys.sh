#!/usr/bin/env bash

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

let current=$(xfconf-query -c a1ccessibility -p /MouseKeys/MaxSpeed)
let next="($current + 1000) % 6000"

if [ "$current" == "0" ]; then
  xfconf-query -c accessibility -p /MouseKeys -s "true"
elif [ "$next" == "0" ]; then
  xfconf-query -c accessibility -p /MouseKeys -s "false"
fi

xfconf-query -c accessibility -p /MouseKeys/MaxSpeed -s "$next"
xfsettingsd --replace &
