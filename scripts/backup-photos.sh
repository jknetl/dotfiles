#!/bin/bash
#
# backup-photos.sh
# ================
# A simple script for backing up photos from my laptop to ssd

if [[ $# -lt 2 ]]; then
  echo "usage: backup-photos.sh SOURCE_DIR DESTINATION_DIR"
  exit 1
fi

source_dir=${1}
dest_dir=${2}

sync.sh "$source_dir" "$dest_dir"

