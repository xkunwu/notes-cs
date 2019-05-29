---
---
### Batch reduce image size

```
for file in *.jpg; do convert -resize 25% $file $file; done
```

### Reduce video size
```
# scale down to 640x480 (no upscaling), padding if necessary, remove audio
ffmpeg -i input.mp4 -vcodec libx264 -crf 24 -an -filter:v "scale='min(640,iw)':min'(480,ih)':force_original_aspect_ratio=decrease,pad=640:480:(ow-iw)/2:(oh-ih)/2" output.24.mp4
```

### Convert to gif
```
ffmpeg -i CenterPiece.mp4  -r 10 CenterPiece.gif
convert -loop 0 frames/*.png output.gif
# default delay is 5x100, so the following will make it quicker:
convert -loop 0 -delay 1x30 -dispose Background anim_00*.png blob_fish.gif
```

### Compress PDF:

```
:: -dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
:: -dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
:: -dPDFSETTINGS=/printer  (high quality, 300 dpi images)
:: -dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
:: -dPDFSETTINGS=/default  (almost identical to /screen)

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/prepress -sOutputFile=output.pdf input.pdf

"C:\Program Files\gs\gs9.21\bin\gswin64c" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/screen -sOutputFile=output.pdf input.pdf

"C:\Program Files\gs\gs9.21\bin\gswin64c" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dDownsampleColorImages=true -dDownsampleGrayImages=true -dDownsampleMonoImages=true -dColorImageResolution=150 -dGrayImageResolution=150 -dMonoImageResolution=150 -dColorImageDownsampleThreshold=1.0 -dGrayImageDownsampleThreshold=1.0 -dMonoImageDownsampleThreshold=1.0 -o output-150.pdf input.pdf
```
