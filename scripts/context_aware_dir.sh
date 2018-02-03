#!/usr/bin/env bash
# Basically we look for a valid path in the title of the current application
#  to become the working directory for a command call.
# In order for it to work, the *full* path must naturally appear in the title
#  of your application, configure your applications accordingly.
# NOTE: this won't work for directories with spaces in their name though with
#  some extension to the regular expression it probably could be made to work
#  but since I never put spaces in my paths, I don't feel the need to do it.

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

i3-msg -t get_tree | python3 -c "
import os
import re
import sys
import json
import jsonpath

props = jsonpath.jsonpath(
  json.load(sys.stdin),
  '$..nodes[?(@.focused)].window_properties',
)[0]

m = re.search(r'~?(/[^ \/]+)+', props['title'])
ms = m.group(0)
if ms:
  ms = ms.replace('~', os.environ['HOME'])
if os.path.isdir(ms):
  print(ms)
elif os.path.isfile(ms):
  print(os.path.dirname(ms))
else:
  print('')
"
