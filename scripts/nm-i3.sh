#!/bin/bash
#
# nm-applet-i3.sh
# ===============
# Script for executing nm-applet on i3 startup. From some reason if it is executed immediately
# during startup then it doesnt' connect to wifi networks.

pkill nm-applet
sleep 2
nohup nm-applet &
