#!/bin/bash

shrink ()
{
	gs					\
	  -q -dNOPAUSE -dBATCH -dSAFER		\
          -dPrinted=false			\
	  -sDEVICE=pdfwrite			\
	  -dCompatibilityLevel=1.5		\
	  -dPDFSETTINGS=/screen			\
	  -dEmbedAllFonts=true			\
	  -dSubsetFonts=true			\
	  -dAutoRotatePages=/None		\
	  -dColorImageDownsampleType=/Bicubic	\
	  -dColorImageResolution=$3		\
	  -dGrayImageDownsampleType=/Bicubic	\
	  -dGrayImageResolution=$3		\
	  -dMonoImageDownsampleType=/Bicubic	\
	  -dMonoImageResolution=$3		\
	  -sOutputFile="$2"			\
	  "$1"
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
		# printf "(NOTE: Input smaller than output) "
		# rm $2
	fi
}

usage ()
{
	echo "Reduces PDF filesize by lossy recompressing with Ghostscript."
	echo "Not guaranteed to succeed, but usually works."
	echo "  Usage: $1 infile [resolution_in_dpi (300)] [outfile_suffix]"
}

IFILE=$1

# Need an input file:
if [ -z "$IFILE" ]; then
	usage "$0"
	exit 1
fi

# Output resolution defaults to 300 unless given:
res=${2-300}

# Output filename defaults to add resolution suffix unless given:
suffix="${3-$res}"

# substitute filename string
shrink_file ()
{
	IFILE=$1
	printf "%s --> \n" "$IFILE"
	# OFILE="${IFILE/%.pdf/$suffix.pdf}"
    # OFILE="${IFILE%.*}.pdf"
    OFILE="${IFILE%.*}.$suffix.pdf"
	# OFILE=${OFILE// /_} # replace space by underscore
	printf "%s" "$OFILE"
	printf " ... "
	shrink "$IFILE" "$OFILE" "$2" || exit $?
	check_smaller "$IFILE" "$OFILE"
	printf "done.\n"
}

# check if the first argument is a directory name
if [ -d "$IFILE" ]; then
	find "$IFILE" -type f -name "*.pdf" -print0 | 
	while IFS= read -r -d '' file; do
		shrink_file "$file" $res
	done
	echo "directory \"$IFILE\" processed."
elif [ -f "$IFILE" ]; then
	shrink_file "$IFILE" $res
else
	echo "$IFILE is not valid";
	exit 1;
fi
