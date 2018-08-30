### This prints the file count per directory for the current directory level:
```
find . -maxdepth 1 -type d -print0 | while read -d '' -r dir; do num=$(find "$dir" -ls | wc -l); printf "%5d files in directory %s\n" "$num" "$dir"; done | sort -rn -k1
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

### To recursively give **directories** read&execute privileges:
```
find /path/to/base/dir -type d -exec chmod 755 {} +
```

#### To recursively give **files** read privileges:
```
find /path/to/base/dir -type f -exec chmod 644 {} +
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
