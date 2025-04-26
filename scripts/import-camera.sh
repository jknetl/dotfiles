#!/bin/bash
#
# import-camera.sh
# ================
# Imports photos and videos from sd-card. It expects specific dir structure to sony a6000 and maybe other similar cameras.
# The script imports raw, jpegs and videos to separate folders.
#
# usage: import-camera.sh OUTPUT_DIR

set -x 

function usage(){
    echo "usage: import-camera.sh OUTPUT_DIR"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

OUTPUT_DIR="$1"
JPG_DIR=$OUTPUT_DIR/jpg
RAW_DIR=$OUTPUT_DIR/raw
VIDEO_DIR=$OUTPUT_DIR/video

if $(fgrep -i ubuntu /etc/os-release > /dev/null); then
  MEDIA_DIR="/media/$USER/"
else
  MEDIA_DIR="/run/media/$USER/"
fi

SD_CARD_ROOT=""

for f in $MEDIA_DIR/*; do
  if [ -d $f -a -d $f/DCIM ] ; then
      SD_CARD_ROOT="$f/"
  fi
done

if [ -z "$SD_CARD_ROOT" ]; then
    echo "No SD card found"
    exit 2
fi

# count number of files (excluding hidden files) in directory
function count_files {
    # We subtract 1 because ls -l shows total and number of inodes on the first line
    #echo $(($(ls -l $1 | wc -l)-1))
    #echo $(ls -1q $1 | wc -l)
    echo $(find $1 -maxdepth 1 -type f ! -name ".*" | wc -l)
}

# counts number of files with a given extension (excluding hidden files)
function count_files_ext {
    echo $(find $1 -maxdepth 1 -type f -iname "*.$2" ! -name ".*" | wc -l)
}

# finds first MSDCF dir in SD_CARD_ROOT (sd card root is argument)
function find_msdcf_dir {
   echo $(find $1/DCIM/ -type d -name "*MSDCF")
}

PHOTOS_SOURCE=$(find_msdcf_dir $SD_CARD_ROOT)
VIDEOS_SOURCE_STREAM="$SD_CARD_ROOT/PRIVATE/AVCHD/BDMV/STREAM/"
VIDEOS_SOURCE_CLIP="$SD_CARD_ROOT/PRIVATE/M4ROOT/CLIP/"

video_stream_files=$(count_files_ext $VIDEOS_SOURCE_STREAM mts)
video_clip_files=$(count_files_ext $VIDEOS_SOURCE_CLIP mp4)

mkdir -p $JPG_DIR
mkdir -p $RAW_DIR
mkdir -p $VIDEO_DIR

echo "Importing $(count_files_ext $PHOTOS_SOURCE jpg)  JPGs..."
cp $PHOTOS_SOURCE/*.JPG $JPG_DIR
echo "Importing $(count_files_ext $PHOTOS_SOURCE arw)  RAWs..."
cp $PHOTOS_SOURCE/*.ARW $RAW_DIR

echo "Importing $(($video_stream_files + $video_clip_files)) videos..."
if [[ -d $VIDEOS_SOURCE_STREAM && $video_stream_files -ge 1 ]]; then
    cp $VIDEOS_SOURCE_STREAM/* $VIDEO_DIR
fi

if [[ -d $VIDEOS_SOURCE_CLIP  && $video_clip_files -ge 1 ]]; then
    cp $VIDEOS_SOURCE_CLIP/* $VIDEO_DIR
fi

echo "Done!"
