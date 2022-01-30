#!/bin/bash

shrink ()
{
	ffmpeg -i "$1" -vcodec libx265 -crf $3 "$2"
}

usage ()
{
	echo "Compress video through higher CRF of ffmpeg."
	echo "  Usage: $1 infile [crf (23)] [outfile_suffix]"
}

IFILE=$1

# Need an input file:
if [ -z "$IFILE" ]; then
	usage "$0"
	exit 1
fi

# Output crf defaults to 23 unless given:
crf=${2-23}

# Output filename defaults to add crf suffix unless given:
suffix="${3-$crf}"

# substitute filename string
shrink_file ()
{
	IFILE=$1
    printf "%s --> \n" "$IFILE" # quote the file name to allow spaces
    # OFILE="${IFILE%.*}.mp4"
    OFILE="${IFILE%.*}.$suffix.mp4"
	# OFILE=${OFILE// /_} # replace space by underscore
	printf "%s ... " "$OFILE"
	shrink "$IFILE" "$OFILE" "$2" || exit $?
	printf "done.\n"
}

# check if the first argument is a directory name
if [ -d "$IFILE" ]; then
	find "$IFILE" -type f \( -iname "*.mp4" -o -iname "*.flv" \) -print0 | 
	while IFS= read -r -d '' file; do
		shrink_file "$file" $crf
	done
    echo "directory \"$IFILE\" processed."
elif [ -f "$IFILE" ]; then
	shrink_file "$IFILE" $crf
else
	echo "$IFILE is not valid";
	exit 1;
fi
