#!/bin/bash
#
# delete-raws.sh
# ==============
# Script expects JPGs and RAWs in different directories (called DIR/jpg and DIR/raw). It deletes
# all RAW images which don't have equivalent image in jpeg dir. Images are considered equivalent if
# they have same name (except the extension).
#
# usage: delete-raws.sh DIR

function usage(){
    echo "usage delete-raws.sh DIRECTORY"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

DIRECTORY=$1
JPG_DIR=$DIRECTORY/jpg
RAW_DIR=$DIRECTORY/raw

if [ ! -d  $JPG_DIR -o ! -d $RAW_DIR ]; then
    echo "Directory $DIRECTORY doesn't have jpg and raw subdirs."
    echo "Exiting without any action."
    exit 2
fi

FILES_TO_REMOVE=""
for f in $RAW_DIR/* ; do
    RAW_NAME=$(basename $f)
    FILENAME="${RAW_NAME%.*}"
    if [ ! \( -f $JPG_DIR/$FILENAME.JPG -o -f $JPG_DIR/$FILENAME.jpg \) ]; then
        FILES_TO_REMOVE="$FILES_TO_REMOVE $f"
    fi
done


if [ -z "$FILES_TO_REMOVE" ] ; then
    echo "Nothing to remove."
    exit 0
fi

echo "Following files will be removed:"
echo "$FILES_TO_REMOVE"
echo "The script will remove $(echo "$FILES_TO_REMOVE" | wc -w)/$(ls -l $RAW_DIR | wc -l) RAW files. Do you want to continue?"

answer=""

until [  "$answer" = "y"  -o  "$answer" = "n"  ]; do
    read -p "[y/n]: " answer
done

if [ $answer = "n" ]; then
    exit 0;
fi

rm $FILES_TO_REMOVE

