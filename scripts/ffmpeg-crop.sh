#!/bin/bash
TT=$(date +%Y%m%d%H%M%S)
FNAME=$(basename "$1")
EXT="${FNAME##*.}"
FNAME="${FNAME%.*}"
CNT=0

# clip: start and duration
SS=00:00:07
EE=00:00:06
ffmpeg -i "$1" -ss $SS -t $EE -codec copy "$FNAME-$((CNT+1)).mp4"
CNT=$((CNT+1))

# transpose
ffmpeg -i "$FNAME-$CNT.mp4" -vf "transpose=2" -c:v libx264 -preset ultrafast -crf 0 -c:a copy "$FNAME-$((CNT+1)).mp4"
CNT=$((CNT+1))

# rotate to horizontally aligned
ffmpeg -i "$FNAME-$CNT.mp4" -vf "rotate=-4.5*PI/180" -c:v libx264 -preset ultrafast -crf 0 -c:a copy "$FNAME-$((CNT+1)).mp4"
CNT=$((CNT+1))

# cut out margins
CU=140
CD=20
CL=40
CR=124
#ffmpeg -i "$FNAME-$CNT.mp4" -vf "crop=in_w-$CR-$CL:in_h-$CD-$CU:$CL:$CU" -c:v libx264 -preset ultrafast -crf 0 -c:a copy "$FNAME-$CR-$CD-$CL-$CU.mp4"
ffmpeg -i "$FNAME-$CNT.mp4" -vf "crop=in_w-$CR-$CL:in_h-$CD-$CU:$CL:$CU" -c:v libx264 -preset ultrafast -crf 0 -c:a copy "$FNAME-$((CNT+1)).mp4"
CNT=$((CNT+1))

# rescale to 16:9
ffmpeg -i "$FNAME-$CNT.mp4" -vf scale=360x640 -c:v libx264 -preset ultrafast -b:v 1M -an "$FNAME-cs.mp4"

