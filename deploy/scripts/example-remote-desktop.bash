#!/usr/bin/env bash

rdesktop \
    -u [AZURE VM USERNAME] \
    -p [AZURE VM PASSWORD] \
    -k pt \
    -g 1440x900 \
    -T "[WINDOW TITLE]" \
    -N \
    -a 16 \
    -z \
    -xl \
    -r clipboard:CLIPBOARD \
    [AZURE VM IP]
