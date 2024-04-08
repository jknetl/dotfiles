#!/bin/bash
# usage: rm_older_than DIR [DAYS]

function print_usage {
  echo "usage: rm_older_than.sh DIR [DAYS]"
}

if [ $# -lt 1 ]; then
  print_usage
  exit 1
fi

DIR="$1"
DAYS=${2:-30}

find "$DIR" -type f,l -atime +${DAYS} -print0 | xargs -0 /bin/rm -f

# delete empty directories:
# if you delete all file from a directory it changes its access time and
# therefore empty directories would stay on the system another 30 days
# after the last file was deleted.
find "$DIR" -empty -type d -delete
