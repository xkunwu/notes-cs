#!/bin/bash
TT=$(date +%Y%m%d%H%M%S)
FNAME=$(basename "$1")
EXT="${FNAME##*.}"
FNAME="${FNAME%.*}"

CU=25
CD=0
CL=0
CR=0
ffmpeg -i "$FNAME.$EXT" -filter:v "crop=in_w-$CR-$CL:in_h-$CD-$CU:$CL:$CU" -c:a copy "$FNAME-$TT-$CR-$CD-$CL-$CU.$EXT"

SS=00:00:00
EE=00:01:30
#ffmpeg -i "$FNAME.$EXT" -vcodec copy -acodec copy -ss $SS -t $EE "$FNAME-$TT.$EXT"

