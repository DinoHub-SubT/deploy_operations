#!/bin/sh

rdesktop \
    -u kat \
    -p katarina \
    -k pt \
    -g 1440x900 \
    -T "MY REMOTE SERVER" \
    -N \
    -a 16 \
    -z \
    -xl \
    -r clipboard:CLIPBOARD \
    10.0.2.5
