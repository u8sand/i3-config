#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by adding them to WINDOW_ICONS below.
#
# It also re-numbers workspaces in ascending order with one skipped number
# between monitors (leaving a gap for a new workspace to be created). By
# default, i3 workspace numbers are sticky, so they quickly get out of order.
#
# Dependencies
# * xorg-xprop  - install through system package manager
# * i3ipc       - install with pip
# * fontawesome - install with pip
#
# Installation:
# * Download this script and place it in ~/.config/i3/ (or anywhere you want)
# * Add "exec_always ~/.config/i3/i3-autoname-workspaces.py &" to your i3 config
# * Restart i3: $ i3-msg restart
#
# Configuration:
# The default i3 config's keybindings reference workspaces by name, which is an
# issue when using this script because the "names" are constantaly changing to
# include window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1

import i3ipc
import json
import logging
import os
import re
import signal
import sys
import fontawesome as fa
import subprocess as proc

def focused_workspace(i3):
    return [w for w in i3.get_workspaces() if w.focused][0]


# Takes a workspace 'name' from i3 and splits it into three parts:
# * 'num'
# * 'shortname' - the workspace's name, assumed to have no spaces
# * 'icons' - the string that comes after the
# Any field that's missing will be None in the returned dict
def parse_workspace_name(name):
    return re.match('(?P<num>\d+):?(?P<shortname>\w+)? ?(?P<icons>.+)?',
                    name).groupdict()


# Given a dictionary with 'num', 'shortname', 'icons', returns the formatted name
# by concatenating them together.
def construct_workspace_name(parts):
    new_name = str(parts['num'])
    if parts['shortname'] or parts['icons']:
        new_name += ':'

        if parts['shortname']:
            new_name += parts['shortname']

        if parts['icons']:
            new_name += ' ' + parts['icons']

    return new_name


# Return an array of values for the X property on the given window.
# Requires xorg-xprop to be installed.
def xprop(win_id, property):
    try:
        prop = proc.check_output(
            ['xprop', '-id', str(win_id), property],
            stderr=proc.DEVNULL)
        prop = prop.decode('utf-8')
        return re.findall('"([^"]+)"', prop)
    except proc.CalledProcessError as e:
        logging.warn("Unable to get property for window '%d'" % win_id)
        return None


# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names (lower-cased) and the icons can be any text you want to
# display.
#
# Most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
#
# If you're not sure what the WM_CLASS is for your application, you can use
# xprop (https://linux.die.net/man/1/xprop). Run `xprop | grep WM_CLASS`
# then click on the application you want to inspect.
WINDOW_ICONS = json.load(open('%s/settings/icons.json' % (os.environ.get('conf', '.')), 'r'))

# This icon is used for any application not in the list above
DEFAULT_ICON = WINDOW_ICONS['']

def icon_for_window(window):
    # Try all window classes and use the first one we have an icon for
    classes = xprop(window.window, 'WM_CLASS')
    if classes != None and len(classes) > 0:
        for cls in classes:
            cls = cls.lower()  # case-insensitive matching
            if cls in WINDOW_ICONS and WINDOW_ICONS[cls] in fa.icons:
                return fa.icons[WINDOW_ICONS[cls]]
    logging.info('No icon available for window with classes: %s' % str(classes))
    return fa.icons[DEFAULT_ICON]


# renames all workspaces based on the windows present
def rename_workspaces(i3):
    ws_infos = i3.get_workspaces()
    prev_output = None
    for ws_index, workspace in enumerate(i3.get_tree().workspaces()):
        ws_info = ws_infos[ws_index]

        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = '  '.join([icon_for_window(w)
                                        for w in workspace.leaves()])

        prev_output = ws_info.output

        new_name = construct_workspace_name(name_parts)
        i3.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))


# Rename workspaces to just numbers and shortnames, removing the icons.
def on_exit(i3):
    for workspace in i3.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = None
        new_name = construct_workspace_name(name_parts)
        i3.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))
    i3.main_quit()
    sys.exit(0)


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)

    i3 = i3ipc.Connection()

    # Exit gracefully when ctrl+c is pressed
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: on_exit(i3))

    rename_workspaces(i3)

    # Call rename_workspaces() for relevant window events
    def window_event_handler(i3, e):
        if e.change in ['new', 'close', 'move']:
            rename_workspaces(i3)

    i3.on('window', window_event_handler)
    i3.main()
