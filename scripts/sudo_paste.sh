#!/usr/bin/env bash

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

sleep 1 && echo String "$(xclip -selection c -o)" | xmacroplay :0
