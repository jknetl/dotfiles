#!/bin/bash
# Replace home directory with ~
path=$(echo "$1" | sed "s|^$HOME|~|")

# Shorten all but the last segment
echo $(dirname $path |sed -e "s;\(/.\)[^/]*;\1;g")/$(basename $path)

