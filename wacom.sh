#!/bin/bash

# CONFIGURATION

# Set this to your (stylus) device. Find it by running:
# xsetwacom --list devices
DEVICE='Wacom Bamboo 16FG 4x5 Pen stylus'

# These numbers are specific for each device. Get them by running:
# xsetwacom --set "Your device name here" ResetArea
# xsetwacom --get "Your device name here" Area
AREAX=14720
AREAY=9200
SCREEN="DVI-I-3"
# END OF CONFIGURATION

if [ -z "$SCREEN" -o "$SCREEN" = "--help" -o "$SCREEN" = "-help" -o "$SCREEN" = "-h" ]; then
  echo 'This script configures a Wacom tablet to one specific monitor, or to '
  echo 'the entire desktop. In addition, it also reduces the tablet area in '
  echo 'order to keep the same aspect ratio as the monitor.'
  echo
  echo 'How to run this script? Run one of the following lines:'
  CONNECTED_DISPLAYS=`xrandr -q --current | sed -n 's/^\([^ ]\+\) connected.* .*/\1/p'`
  for d in desktop $CONNECTED_DISPLAYS; do
    echo "  $0 $d"
  done
  exit
fi

if [ "$SCREEN" = "desktop" ]; then
  # Sample xrandr line:
  # Screen 0: minimum 320 x 200, current 3286 x 1080, maximum 32767 x 32767

  LINE=`xrandr -q --current | sed -n 's/^Screen 0:.*, current \([0-9]\+\) x \([0-9]\+\),.*/\1 \2/p'`
  read WIDTH HEIGHT <<< "$LINE"
else
  # Sample xrandr lines:
  # LVDS1 connected 1366x768+0+312 (normal left inverted right x axis y axis) 309mm x 174mm
  # VGA1 disconnected (normal left inverted right x axis y axis)
  # HDMI1 connected 1920x1080+1366+0 (normal left inverted right x axis y axis) 509mm x 286mm

  LINE=`xrandr -q --current | sed -n "s/^${SCREEN}"' connected.* \([0-9]\+\)x\([0-9]\+\)+\([0-9]\+\)+\([0-9]\+\).*/\1 \2 \3 \4/p'`
  read WIDTH HEIGHT OFFX OFFY <<< "$LINE"
fi

if [ -z "$WIDTH" -o -z "$HEIGHT" ]; then
  echo "Aborting."
  exit 1
fi

# New values respecint aspect ratio:
RATIOAREAY=$(( AREAX * HEIGHT / WIDTH ))
RATIOAREAX=$(( AREAY * WIDTH / HEIGHT ))

if [ "$AREAY" -gt "$RATIOAREAY" ]; then
  NEWAREAX="$AREAX"
  NEWAREAY="$RATIOAREAY"
else
  NEWAREAX="$RATIOAREAX"
  NEWAREAY="$AREAY"
fi

xsetwacom --set "$DEVICE" Area 0 0 "$NEWAREAX" "$NEWAREAY"
xsetwacom --set "$DEVICE" MapToOutput "${WIDTH}x${HEIGHT}+${OFFX}+${OFFY}"

xsetwacom --set "Wacom Bamboo 16FG 4x5 Pen stylus" Rotate "none"
xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger touch" Touch "off"
