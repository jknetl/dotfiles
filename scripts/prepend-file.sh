#!/bin/bash
#
# prepend-file.sh
# ===============
# This script prepends a file in the first argument into file in the
# second argument.


function usage {
	echo "usage: $0 FILE FILE"
	echo " -- prepends first file to the beginning of the second file"
}

if [ $# -ne 2 ]; then
	echo "Wrong number of args"
	usage
	exit 1
fi

licence_file=$1
file=$2

tmp_file=$(mktemp)

cat $licence_file $file > $tmp_file
mv $tmp_file $file
