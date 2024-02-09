#!/bin/bash
#
# Quickly switch between a given keyboard layout and the US Qwerty one
# (taken from @avano)

CURRENT="$(setxkbmap -query | grep layout | perl -pe 's/^layout: +([^ ]+)$/$1/')"

if [ "$CURRENT" = "us" ] ; then
    setxkbmap -layout "cz(qwerty)"
else
    setxkbmap -layout "us"
fi

