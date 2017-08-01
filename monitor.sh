#!/bin/bash

primary="$(i3-msg -t get_workspaces | python -c "
import sys, json
print([d['output']
       for d in json.load(sys.stdin)
       if d['focused']][0])")"

bash -c "$(xrandr | awk -v primary="$primary" '
$2~/^connected/{
  if($1 != primary)
    connected[++N_connected]=$1;
}
$2~/^disconnected/{
  disconnected[++N_disconnected]=$1;
}
END {
  printf "xrandr --output %s --auto --primary", primary;
  for(i=1;i<=N_connected;i++) {
    printf " --output %s --auto", connected[i];
    if(i==1) {
      printf " --right-of %s", primary;
    } else {
      printf " --right-of %s", connected[i-1];
    }
  }
  for(i=1;i<N_disconnected;i++) {
    printf " --output %s --off", disconnected[i];
  }
  printf "\n";
}')"
