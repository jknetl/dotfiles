#!/bin/bash
# Path to the configuration file
AWS_CONFIG_FILE=$HOME/.aws/config


# Extract profile names from the config file
options=($(sed -n 's/^\[profile \([^]]*\)\].*/\1/p' "$AWS_CONFIG_FILE"))
# Check if options were found
if [ ${#options[@]} -eq 0 ]; then
  echo "No profiles found in the configuration file."
  exit 1
fi

# Use fzf to prompt the user to select an option
selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select an AWS Profile: ")

# Check if a selection was made
if [ -n "$selected_option" ]; then
  echo "$selected_option"
else
  >&2 echo "ERROR: No option selected. AWS_PROFILE not set."
fi
