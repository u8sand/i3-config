#!/bin/bash

cd $(cd $(dirname $0) ; pwd -P)
eval "$(pyenv init -)"
pyenv shell 3.5.1
python autoname_workspaces.py || i3-nagbar -t error -m "Couldn't start autoname_workspaces"
