#!/bin/bash
#
# thumbnails.sh
# =========
# Creates thumbnails.sh recursively
#
# usage: thumbnails.sh DIRECTORY [2400x1200]

SRCDIR=$1
DESTDIR=thumbnails

RESOLUTION=${2:-2400x1200}

function print_usage() {
    echo "usage: $0 DIRECTORY [2400x1200]"
}

# Creates a thumbnail from a jpg file
# usage: create_thumbnail input.jpg output.jpg
function create_thumbnail() {
    convert -resize $RESOLUTION $1 $2
}

# create_thumbnails recursively goes through by each file in the directory and all subdirectories and
# creates a thumbnail in a subdirectory
# usage: create_thumbnails DIR_WITH_IMAGES
function create_thumbnails() {
    local parrent_dir=$(pwd)
    local dir="$1"
    cd "$dir"
    local files=$(ls)
    for f in $files
    do
        if [ -d $f ] && [[ $f != thumbnails ]]
        then
            create_thumbnails $f
        elif [ -f $f ] && ([[ $f = *.jpg ]] || [[ $f = *.JPG ]])
        then
            if [ ! -f "$DESTDIR/$f" ]; then
                mkdir -p "$DESTDIR"
                echo "Creating thumbnail for: $(pwd)/$f"
                create_thumbnail "$f" "$DESTDIR/$f"
            fi
        fi
    done
    cd $parrent_dir
}

if [ -z "$SRCDIR" ]; then print_usage  ; exit 1; fi

create_thumbnails $SRCDIR
