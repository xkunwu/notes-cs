---
---
### Bash variable manipulation
```
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
```
find . -type f -name "*.md" -exec sed -i '1s/^/---\n---\n/' {} \;
```

### This prints the file count per directory for the current directory level:
```
find . -maxdepth 1 -type d -print0 | while read -d '' -r dir; do num=$(find "$dir" -ls | wc -l); printf "%5d files in directory %s\n" "$num" "$dir"; done | sort -rn -k1
```
Or just simply output file count:
```
find . -type f | wc -l
```

### Disk usage summary
```
du -smhc *
```

### Find disk & mount
```
lsblk
sudo mount disk_loc mount_loc
```


### ls directory with large list of file
```
ls -U | more
```

### Count all the lines of code in a directory recursively
```
find . \( -name '*.py' -o -name '*.h' -o -name '*.cpp' \) | xargs wc -l
```


### Copy & Paste
```
# cp - force overwrite without confirmation prompt:
yes | cp -rf

# cp - skip existing files
cp -n

# recursively move a tree:
cp -al source/* dest/ && rm -r source/*
```

----

### To get the details of linked libraries:

```
ldconfig -p | grep libname
```

----

### To recursively give proper privileges:
Note: '+' means arguments to a single command, in contrast to ';' which means run command separately.
```
find . -type d -exec chmod 755 {} \+
find . -type f -exec chmod 644 {} \+
find . -type f -name "*.sh" -exec chmod +x {} \+
```

### Recursively rename file extension:

```
find . -name '*.PNG' -exec rename -v 's/\.PNG$/\.png/i' {} \;
```

----

### Compress PDF:

```
:: -dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
:: -dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
:: -dPDFSETTINGS=/printer  (high quality, 300 dpi images)
:: -dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
:: -dPDFSETTINGS=/default  (almost identical to /screen)

"C:\Program Files\gs\gs9.21\bin\gswin64c" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/screen -sOutputFile=output.pdf input.pdf

"C:\Program Files\gs\gs9.21\bin\gswin64c" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dDownsampleColorImages=true -dDownsampleGrayImages=true -dDownsampleMonoImages=true -dColorImageResolution=150 -dGrayImageResolution=150 -dMonoImageResolution=150 -dColorImageDownsampleThreshold=1.0 -dGrayImageDownsampleThreshold=1.0 -dMonoImageDownsampleThreshold=1.0 -o output-150.pdf input.pdf
```
