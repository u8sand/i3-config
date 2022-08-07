#!/bin/sh

LOGINCTL_SESSION_ID=$(loginctl session-status | awk 'NR==1 { print $1 }')
loginctl lock-session ${LOGINCTL_SESSION_ID}

