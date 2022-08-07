#!/bin/sh

# Using the CONTEXT environment variable, we can augment how we execute a
#  given command -- for now we mainly case about ssh for seemless context-aware-ssh
#  when we're e.g. looking at a remote folder, or want to open a new terminal.

CONTEXT=$1
if [ ! -z "${CONTEXT}" ]; then
  _uri="$(echo ${CONTEXT} | sed 's/^\([^ :]\{1,\}:\/\/[^\/]*\)\{,1\}\(.\{1,\}\)$/\1/')"
  _path="$(echo ${CONTEXT} | sed 's/^\([^ :]\{1,\}:\/\/[^\/]*\)\{,1\}\(.\{1,\}\)$/\2/')"
  if [ ! -z "${_uri}" ]; then
    # Custom terminal handling of varous URI protocols
    echo "${_uri}" | grep -q '^ssh://'
    if [ "$?" -eq "0" ]; then
		  code -n --remote "ssh-remote+$(echo ${_uri} | cut -c7-)" "${_path}"
      exit $?
    fi

    echo "${_uri}" | grep -q '^sftp://'
    if [ "$?" -eq "0" ]; then
		  code -n --remote "ssh-remote+$(echo ${_uri} | cut -c8-)" "${_path}"
      exit $?
    fi
  fi
fi

code -n $@

