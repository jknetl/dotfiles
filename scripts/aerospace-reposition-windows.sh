#!/bin/bash
# Simple aerospace script to set the application windows to my preferred workspaces

# $1 = app name (grep filter)
# $2 = workspace number/letter
function move_app_to_workspace() {
  window_ids=$(aerospace list-windows --all | grep -i $1 | awk '{print $1}')
  for id in $window_ids; do
    aerospace move-node-to-workspace --window-id "$id" $2
  done
}

# Move all Firefox windows to workspace 1
move_app_to_workspace firefox 1
move_app_to_workspace ghostty 2
move_app_to_workspace intellij 4
move_app_to_workspace obsidian 6
move_app_to_workspace slack 7
move_app_to_workspace zoom87
move_app_to_workspace teams 8
move_app_to_workspace outlook 10
