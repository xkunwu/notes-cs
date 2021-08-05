---
...
### Bash variable manipulation

```sh
Delete the shortest match of string in $var from the beginning:
${var#string}
Delete the longest match of string in $var from the beginning:
${var##string}
Delete the shortest match of string in $var from the end:
${var%string}
Delete the longest match of string in $var from the end:
${var%%string}
example:
${PWD##*/}
${var*.zip}
```

### Add file header to each of the files

```sh
find . -type f -name "*.md" -exec sed -i '1s/^/---\n---\n/' {} \;
find . -regextype posix-extended -regex ".*\.py($|\..*)" -type f -exec sed -i '1 e cat HEADER' {} \;
```

### This prints the file count per directory for the current directory level:

```sh
find . -maxdepth 1 -type d -print0 | while read -d '' -r dir; do num=$(find "$dir" -ls | wc -l); printf "%5d files in directory %s\n" "$num" "$dir"; done | sort -rn -k1
```

Or just simply output file count:

```sh
find . -type f | wc -l
```

### Count all the lines of code in a directory recursively

```sh
{ echo "Line counts for project: $(pwd)" & echo "Generated at: $(date)" ; find . -type f \( -name '*.py' -o -name '*.h' -o -name '*.cpp' \) | xargs wc -l ; } | cat > line-count.txt
```

### Copy & Paste

```sh
# cp - force overwrite without confirmation prompt:
yes | cp -rf
# cp - skip existing files
cp -n
# recursively move a tree:
cp -al source/* dest/ && rm -r source/*
```

### To recursively give proper privileges:

Note: '+' means arguments to a single command, in contrast to ';' which means run command separately.

```sh
find . -type d -exec chmod 755 {} \+
find . -type f -exec chmod 644 {} \+
find . -type f -name "*.sh" -exec chmod +x {} \+
```

### Recursively rename file extension:

```sh
find . -name '*.PNG' -exec rename -v 's/\.PNG$/\.png/i' {} \;
```

### Extracting embedded images from a PDF:

```sh
pdfimages -j in.pdf /tmp/out

-j:  Normally, all images are written as PBM (for monochrome images) or PPM for
     non-monochrome images) files. With this option,  images in DCT format are
     saved as JPEG files. All non-DCT images are saved in PBM/PPM format as usual.
```

### Merge PDFs

```sh
pdftk file1.pdf file2.pdf cat output mergedfile.pdf

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=mergedfile.pdf file1.pdf file2.pdf
```
