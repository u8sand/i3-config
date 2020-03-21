#!/usr/bin/env bash

# Basically we look for a valid path in the title of the current application
#  to become the working directory for a command call.
# In order for it to work, the *full* path must naturally appear in the title
#  of your application, configure your applications accordingly.
#
# We also detect URIs and can perform some specific protocol-aware context
#  handling. See `with_context.sh` for more information.
#  If you want to take advantage of this with your terminal you'll need the following in your .*rc
# On both host and remote
# bash:
#   if [ -z "$SSH_CLIENT" ]; then
#     export PROTO=""
#   else
#     export PROTO="ssh://$(whoami)@$(hostname)"
#   fi
#   PROMPT_COMMAND='echo -en "\033]0;${PROTO}$(pwd)\a"'
# zsh:
#   if [ -z "$SSH_TTY" ]; then
#     export PROTO=""
#   else
#     export PROTO="ssh://$(whoami)@$(hostname)"
#   fi
#   precmd() {
#     print -Pn "\e]0;${PROTO}${PWD}\a"
#   }
#
# NOTE: this won't work for directories with spaces in their name though with
#  some extension to the regular expression it probably could be made to work
#  but since I never put spaces in my paths, I don't feel the need to do it.

# Primary: Find path from title
#  This is the best way, given that the program
#  in question puts full paths in the title.
# Fallback: Find path from process
#  This is a way usually doesn't work because most
#  programs don't change from their startup directory.
#  Still, if it isn't HOME, it's likely the startup
#  directory of the program is also the directory
#  you're looking for.

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

PWD=$(i3-msg -t get_tree | python3 -c "
import os
import re
import sys
import json
import jsonpath

props = jsonpath.jsonpath(
  json.load(sys.stdin),
  '$..nodes[?(@.focused)]',
)[0]

m = re.search(r'(?P<prefix>(?P<uri>[^ :]+://[^/]*)|(?P<tilde>~))?(?P<path>(?P<partial_path>/[^ \/]+)+)', props['window_properties']['title'])
if m:
  ms = m.group('path')
  if m.group('tilde'):
    ms = os.environ['HOME'] + ms
  elif m.group('uri'):
    if m.group('uri') != 'file://':
      ms = m.group('uri') + ms
      print(ms)
      exit(0)
  if os.path.isdir(ms):
    print(ms)
    exit(0)
  elif os.path.isfile(ms):
    print(os.path.dirname(ms))
    exit(0)
print(props['window'])
exit(1)
")

if [ "$?" -eq "1" ]; then
  PWD=$(pwdx \
        $( \
          xprop -id ${PWD} \
          | awk -F'=' '/^_NET_WM_PID/{print $2}' \
        ) | awk -F': ' '{print $2}' \
      )
fi

echo "${PWD}"
