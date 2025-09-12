#!/bin/zsh
# This script searches for a specific pattern definition in yaml files 
# Usage example:
# yamldef.sh <PATTERN>
# e.g. yamldef.sh config.application.url

PATTERN=$1
if [ -z "$PATTERN" ]; then
  echo "Usage: yamldef.sh <PATTERN>"
  echo "Example: "
  echo "yamldef.sh config.application.url"
  exit 1
fi

yq "select(.${PATTERN}) | (filename + \":\" + (line | tostring) + \": \" + (.${PATTERN} | @json))" **/*.yaml

