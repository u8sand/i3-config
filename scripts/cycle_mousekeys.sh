#!/bin/bash

let current=$(xfconf-query -c accessibility -p /MouseKeys/MaxSpeed)
let next="($current + 2000) % 6000"

if [ "$current" == "0" ]; then
  xfconf-query -c accessibility -p /MouseKeys -s "true"
elif [ "$next" == "0" ]; then
  xfconf-query -c accessibility -p /MouseKeys -s "false"
fi

xfconf-query -c accessibility -p /MouseKeys/MaxSpeed -s "$next"
xfsettingsd --replace &
