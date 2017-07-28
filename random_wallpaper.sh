#!/bin/bash

# dir=/home/u8sand/Pictures/Wallpapers/
# feh -rz --bg-fill "$dir"

dir=~/Pictures/Wallpapers/
disps=(DVI-I-1 DVI-I-2)
find "$dir" -type f | shuf -n ${#disps[@]} | xargs feh -rz --bg-fill
