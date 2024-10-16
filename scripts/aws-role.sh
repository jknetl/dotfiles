#!/bin/bash
# Interactively chooses an AWS_PROFILE from the aws based on currently used profile
# It offers only the different role for the same account which is ucrrently active
# If there is no active profile, it will show all the profiles

# Path to the configuration file
AWS_CONFIG_FILE=$HOME/.aws/config

# Extract profile names from the config file
options=($(sed -n 's/^\[profile \([^]]*\)\].*/\1/p' "$AWS_CONFIG_FILE"))

current_profile=$AWS_PROFILE

if [ ! -z "$current_profile" ]; then
  # the current_profile starts has two parts separated by a '/' filter out options which have different first part
  current_account=$(echo $current_profile | cut -d'/' -f1)
  options=($(printf "%s\n" "${options[@]}" | grep "$current_account"))
fi


# Check if options were found
if [ ${#options[@]} -eq 0 ]; then
  >&2 echo "No profiles found in the configuration file."
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
