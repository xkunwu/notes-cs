#!/bin/bash

path=${1-.}

find $path -type f '(' \
    -name '*.log' \
    -o -name '*.aux' \
    -o -name '*.bbl' \
    -o -name '*.bcf' \
    -o -name '*.bit' \
    -o -name '*.blg' \
    -o -name '*.dvi' \
    -o -name '*.fdb_latexmk' \
    -o -name '*.fls' \
    -o -name '*.idx' \
    -o -name '*.ilg' \
    -o -name '*.ind' \
    -o -name '*.glo' \
    -o -name '*.lof' \
    -o -name '*.lot' \
    -o -name '*.out' \
    -o -name '*.run.xml' \
    -o -name '*.synctex.gz' \
    -o -name '*.toc' \
    -o -name '.DS_Store' \
    ')' \
    -delete

