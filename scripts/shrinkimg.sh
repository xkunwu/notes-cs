#!/bin/bash

shrink ()
{
	# magick convert \
	# 	-interlace Plane \
	# 	-sampling-factor 4:2:0 \
	# 	-define jpeg:dct-method=float \
	# 	-quality $3% \
    #     -resize "1600x1000>" \
	# 	-set units PixelsPerInch -density 72 \
	# 	$1 \
	# 	$2
	magick mogrify \
    -thumbnail "1600x1000>" \
    -filter Triangle -define filter:support=2 -define jpeg:fancy-upsampling=off \
    -unsharp 0.25x0.25+8+0.065 \
    -posterize 136 -dither None \
    -colorspace sRGB \
    -quality 82 -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 \
    -strip -define png:exclude-chunk=all \
	-write $2 \
    $1
}

check_smaller ()
{
	# If $1 and $2 are regular files, we can compare file sizes to
	# see if we succeeded in shrinking. If not, we copy $1 over $2:
	if [ ! -f "$1" -o ! -f "$2" ]; then
		return 0;
	fi
	ISIZE="$(echo $(wc -c "$1") | cut -f1 -d\ )"
	OSIZE="$(echo $(wc -c "$2") | cut -f1 -d\ )"
	if [ "$ISIZE" -lt "$OSIZE" ]; then
		printf "(NOTE: Input smaller than output, doing straight copy) "
		cp "$1" "$2"
	fi
}

usage ()
{
	echo "Compress image for the web using ImageMagick."
	echo "  Usage: $1 infile [outpath]"
}

IFILE=$1

# Need an input file:
if [ -z "$IFILE" ]; then
	usage "$0"
	exit 1
fi

# substitute filename string
shrink_file ()
{
	IFILE=$1
	printf "%s --> \n" "$IFILE"
    # # filename_base=`basename $IFILE`
    filename_base=${IFILE##*/}
    extension=${filename_base##*.}
    filename=${filename_base%.*}
	filename_dir=${IFILE%/*}
	OUTPATH=${2-${filename_dir}}
	# if [ -z ${2+x} ]; then
	# 	OFILE="${OUTPATH}/${filename}.web.${extension}";
	# else
	# fi
	OFILE="${OUTPATH}/${filename}.${extension}";
	# OFILE=${OFILE// /_} # replace space by underscore
	printf "%s ... " "$OFILE"
	shrink "$IFILE" "$OFILE" "$2" || exit $?
	check_smaller "$IFILE" "$OFILE"
	printf "done.\n"
}

if [ -z ${2+x} ]; then
	echo 'WARNING: magick mogrify will be called, which OVERWRITES original files.'
	read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
fi

# check if the first argument is a directory name
if [ -d "$IFILE" ]; then
	find "$IFILE" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | 
	while IFS= read -r -d '' file; do
		shrink_file "$file" $2
	done
	echo "directory \"$IFILE\" processed."
elif [ -f "$IFILE" ]; then
	shrink_file "$IFILE" $2
else
	echo "$IFILE is not valid";
	exit 1;
fi
