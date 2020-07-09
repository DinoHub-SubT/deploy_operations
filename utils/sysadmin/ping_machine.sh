#!/bin/bash
# Joshua Spisak <joshs333@live.com> July 9, 2020
# Simple script to print whether or not a machine is connected by pinging it every n seconds.
ip=$1
sleep_interval=$2

# Ensure we have a url to ping / test
if [ -z $ip ] || [ "$ip" == "-h" ]; then
    echo "Usage: ping_machine.sh <ip / hostname> <ping interval>"
    echo "  <ip / hostname> exactly what it says, some address to ping"
    echo "  <ping interval> interval at which to ping / test connection (in seconds) (default: 1)"
    echo
    echo "Pings a given machine at a specified interval, simply prints whether or not the machine is connected."
    exit 0
fi

# Default sleep to 1 second if none passed as argument
if [ -z $sleep_interval ]; then
    sleep_interval=1
fi

connection="na"
while [ true ]; do
    ping -c 1 -W 1 $ip &> /dev/null
    result=$?
    if [ "$result" == "0" ]; then
        if [ "$connection" == "na" ] || [ "$connection" == "no" ]; then
            connection="yes"
            echo "Connected to [$ip] at $(date)"
        fi
    else
        if [ "$connection" == "na" ] || [ "$connection" == "yes" ]; then
            connection="no"
            echo "Disconnected from [$ip] at $(date)"
        fi
    fi
    sleep $sleep_interval
done
