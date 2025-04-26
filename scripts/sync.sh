#!/bin/bash
#
# sync.sh
# ================
# A simple script for synchronizing files using rsync.

source_dir=${1}
dest_dir=${2}

function print_usage {
  echo "usage: sync.sh SOURCE_DIR DESTINATION_DIR"
}


if [ -z "$source_dir" ]; then
    print_usage
    exit 1
fi

if [ -z "$dest_dir" ]; then
    print_usage
    exit 1
fi

if [ ! -d "$source_dir" ]; then
    echo "Source directory doesn't exists: $source_dir" >&2
    exit 2
fi

if [ ! -d "$dest_dir" ]; then
    echo "Source directory doesn't exists: $dest_dir" >&2
    exit 3
fi

echo "Running in dry run:"

# RSYNC_EXTRA_PARAMS allows to hook up special params when calling sync.sh from different scripts

RSYNC_OPTS="${RSYNC_EXTRA_PARAMS} -av"
# grep skips directories in output
rsync $RSYNC_OPTS -n "$source_dir" "$dest_dir" | grep -v '/$'

echo ""
echo "INFO: Running without --delete option. No files will be removed."
echo ""

read -p "Would you like to proceed? [y/n]: " input

until [ $input == "y" -o $input == "n" ]; do
    read -p "Would you like to proceed? Enter \"y\" or \"n\": " input
done

if [ $input == "n" ]; then
    exit 0
fi

echo "syncing..."
rsync $RSYNC_OPTS "$source_dir" "$dest_dir"
