#!/usr/bin/bash
#
# originally inspired by: https://gist.github.com/Nervengift/844a597104631c36513c

# choose pulseaudio sink via rofi or dmenu
# changes default sink and moves all streams to that sink

source=$(ponymix -t source list|awk '/^source/ {s=$1" "$2;getline;gsub(/^ +/,"",$0);print s" "$0}'| grep -v 'Monitor of' |rofi -dmenu -i -p 'pulseaudio source:' -location 6 -width 100|grep -Po '[0-9]+(?=:)') &&
# alternate version using dmenu:
# sink=$(ponymix -t sink list|awk '/^sink/ {s=$1" "$2;getline;gsub(/^ +/,"",$0);print s" "$0}'|dmenu -p 'pulseaudio sink:'|grep -Po '[0-9]+(?=:)') &&

ponymix set-default -d $source &&
for input in $(ponymix list -t sink-input|grep -Po '[0-9]+(?=:)');do
	echo "$input -> $source"
	ponymix -t sink-input -d $input move $source
done
