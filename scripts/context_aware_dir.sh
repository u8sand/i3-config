#!/bin/bash
# This command is magical and awesome, basically on a per-application basis we extract the current
#  working directory for context-aware commands.
# These depend on, in many cases, the title which may need to be adjusted accordingly for each app.
# visual-studio-code:
#  User Settings: "window.title": "${dirty}${activeEditorLong} - ${folderName} - ${appName}",
# nemo:
#  Edit -> Preferences -> Display -> Check Show the full path in the title bar and tab bars
# sublime-text-3:
#  User settings: "show_full_path": true,
# xfce4-terminal:
#  echo 'precmd() { print -Pn "\e]0;$PWD\a" }' >> ~/.zshrc
#  echo 'DISABLE_AUTO_TITLE="false"' >> ~/.zshrc
#  Edit -> Preferences -> Dynamically-set title: Replaces initial title

eval "$(pyenv init -)"
pyenv shell 3.5.1

i3-msg -t get_tree | python -c "
import re, sys, json, jsonpath
def re_or(r, s, g, o=''):
  m = re.match(r, s)
  return m.group(g) if m else o
print(
  (lambda props: {
    'code': lambda p: re_or(r'^(. )?(.*)/.* - .* - .+$', p['title'], 2).replace('~', '$HOME'),
    'nemo': lambda p: re_or(r'^(.*) - (.+)$', p['title'], 2),
    'subl3': lambda p: re_or(r'^(.*)/.* (. )?\(.*\) - .+$', p['title'], 1).replace('~', '$HOME'),
    'xfce4-terminal': lambda p: p['title'],
  }.get(props['instance'], '')(props))(
    jsonpath.jsonpath(
      json.load(sys.stdin),
      '$..nodes[?(@.focused)].window_properties')[0]
  ))"
