#!/bin/bash
#
# timelapse.sh
# ============
# Creates a timelapse from pictures in a folder.
#
# WARNING: it renames all pictures in the folder!


answer="nothing"
while [[ $answer != "y" || $answer != "n" ]]; do
  read -p "WARNING. This script renames all pictures in the folder. Do you want to continue? [y/n]: " answer
  if [[ $answer == "n" ]]; then
    exit 0
  fi
done


FPS=24
OUTFILE=output-final.avi

jhead -n%Y%m%d-%H%M%S *.JPG
ls -1tr | grep -v files.txt > files.txt
mencoder -nosound -noskip -oac copy -ovc copy -o output.avi -mf fps="$FPS" 'mf://@files.txt'

# with cropping from 4:3
#ffmpeg -i output.avi -y -qscale 0 -vf scale=1920:1440,crop=1920:1080 "$OUTFILE"
#TODO: find out option which allows to take percentage for scaling in order to avoid cropping
ffmpeg -i output.avi -y -qscale 0 -vf scale=1920:1080 "$OUTFILE"
rm output.avi files.txt
