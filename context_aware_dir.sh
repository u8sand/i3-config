#!/bin/bash
# This command is magical and awesome, basically on a per-application basis we extract the current
#  working directory for context-aware commands.

eval "$(pyenv init -)"
pyenv shell 3.5.1

i3-msg -t get_tree | python -c "
import re, sys, json, jsonpath
def re_or(r, s, g, o=''):
  m = re.match(r, s)
  return m.group(g) if m else o
print(
  (lambda props: {
    'xfce4-terminal': lambda p: p['title'],
    'nemo': lambda p: re_or(r'^(.*) - (.+)$', p['title'], 2),
    'subl3': lambda p: re_or(r'^(.*)/.* (. )?\(.*\) - .+$', p['title'], 1).replace('~', '$HOME'),
    'code': lambda p: re_or(r'^(. )?(.*)/.* - .* - .+$', p['title'], 2).replace('~', '$HOME'),
  }.get(props['instance'], '')(props))(
    jsonpath.jsonpath(
      json.load(sys.stdin),
      '$..nodes[?(@.focused)].window_properties')[0]
  ))"
