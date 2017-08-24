#!/bin/bash

sleep 1 && echo String "$(xclip -selection c -o)" | xmacroplay :0
