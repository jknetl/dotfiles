#!/bin/bash
# script to run when pc is docked/undocked


echo "$(date) - connected " >> ~/tmp/udev-log

xset r rate 200 60 >>  ~/tmp/udev-log 2>&1
