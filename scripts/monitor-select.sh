#!/bin/bash

layouts_dir="$HOME/.screenlayout/"

layouts=$(ls $layouts_dir)

echo $layouts
selected=$(echo "$layouts" | rofi -dmenu -p "Select layout")

#run the script
$layouts_dir/$selected


#restore screen layout
sleep 1
nitrogen --restore
