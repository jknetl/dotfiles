#!/bin/bash
#
# battery-tester.sh
# =================
# USAGE: battery-tester.sh [outfile]
#
# Script for estimating battery life. This script should run infinitely
# until a battery of laptop dies. It writes time to an output file.

OUTFILE={$1:battery-status.txt}

if [ -e "$OUTFILE" ]; then
    until [ $input == "y" -o $input == "n" ]; do
        read -p "File $OUTFILE already exists do you want to overwrite it? [y/n]: "  input
    done
    if [ $input == "n" ]; then
        echo "Exiting without overwriting file."
    else
        echo "Starting to monitor battery. Output goes into $OUTFILE"
    fi
fi


while true ; do
    date +%T >> $OUTFILE
    cat /sys/class/power_supply/BAT0/energy_now >> $OUTFILE
    sync
    sleep 60
done

