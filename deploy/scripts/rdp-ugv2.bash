#!/usr/bin/env bash

rdesktop \
    -u subt \
    -p Password1234! \
    -k pt \
    -g 1440x900 \
    -T "ugv2" \
    -N \
    -a 16 \
    -z \
    -xl \
    -r clipboard:CLIPBOARD \
    azure-ugv2
