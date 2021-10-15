#!/usr/bin/env python

import sh
import json
import click
from functools import partial

ignore = [
    ('MESSAGE', "proc: Bad value for 'hidepid'"),
    ('_COMM', 'nmbd'),
    ('_COMM', 'winbindd'),
]

@click.command()
def journalctl_inotify():
  stream = sh.journalctl(
    '-p', 'err',
    '-o', 'json',
    '-f', '-n', '0',
    _iter=True,
  )
  stream = map(json.loads, stream)
  stream = filter(lambda msg: set(msg.items())&set(ignore), stream)
  for msg in stream:
    sh.notify_send(
      'journalctl-inotify', msg['MESSAGE'],
      '--icon', 'dialog-error',
    )

if __name__ == '__main__':
  journalctl_inotify()
