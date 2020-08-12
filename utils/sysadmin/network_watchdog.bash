#!/usr/bin/env bash

pause=1
host="ugv1"
if [ ! -z "$CHECK_HOST" ]; then
    host=$CHECK_HOST
fi
if [ ! -z "$CHECK_PAUSE" ]; then
    pause=$CHECK_PAUSE
fi

# NOTE: Invert logic... 1=false, 0=true
ping_ppc=(0)
has_pinged=(1)
while [ true ]; do
    ping -c 1 -W 1 $host
    ping_ppc=$?

    if [ $ping_ppc == 0 ] && [ $has_pinged == 0 ]; then
        has_pinged=(0)
        echo "Still connected at $(date)"
    elif [ $ping_ppc == 0 ] && [ $has_pinged == 1 ]; then
        has_pinged=(0)
        echo "Connected at $(date)"
    elif [ $ping_ppc != 0 ] && [ $has_pinged == 0 ]; then
        has_pinged=(1)
        echo "Disconnected at $(date), restarting networking..."
        service networking restart
    elif [ $ping_ppc != 0 ] && [ $has_pinged == 1 ]; then
        has_pinged=(1)
        echo "Still disconnected at $(date)"
    fi

    sleep $pause
done
