---
---
### Batch reduce image size

```sh
for file in *.jpg; do convert -resize 25% $file $file; done
```

[Efficient Image Resizing With ImageMagick](https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/)

```sh
mogrify -path OUTPUT_PATH \
    -thumbnail OUTPUT_WIDTH \
    -filter Triangle -define filter:support=2 -define jpeg:fancy-upsampling=off \
    -unsharp 0.25x0.25+8+0.065 \
    -posterize 136 -dither None \
    -colorspace sRGB \
    -quality 82 -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 \
    -strip -define png:exclude-chunk=all \
    -interlace none \
    INPUT_NAME

mogrify -filter Triangle -define filter:support=2 -define jpeg:fancy-upsampling=off -unsharp 0.25x0.25+8+0.065 -posterize 136 -dither None -colorspace sRGB -quality 82 -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -strip -define png:exclude-chunk=all -thumbnail "1600x1000>" -interlace none -path OUTPUT_PATH INPUT_NAME
```

### Reduce video size

```sh
# scale down to 640x480 (no upscaling), padding if necessary, remove audio
ffmpeg -i input.mp4 -vcodec libx264 -crf 24 -an -filter:v "scale='min(640,iw)':min'(480,ih)':force_original_aspect_ratio=decrease,pad=640:480:(ow-iw)/2:(oh-ih)/2" output.24.mp4
```

### Convert to gif

```sh
ffmpeg -i output.24.mp4 -r 10 output.gif
convert -loop 0 frames/*.png output.gif
# default delay is 5x100, so the following will make it quicker:
convert -loop 0 -delay 1x30 -dispose Background anim_00*.png blob_fish.gif
```

### Crop, resize and convert to gif

```sh
magick mogrify -crop 800x800+600+0 +repage -resize 400x400^ +repage -path ./crop *.jpg
convert -loop 0 -delay 30 ./crop/*.jpg ebike.gif
```

### Compress PDF

```batch
:: -dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
:: -dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
:: -dPDFSETTINGS=/printer  (high quality, 300 dpi images)
:: -dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
:: -dPDFSETTINGS=/default  (almost identical to /screen)

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/prepress -sOutputFile=output.pdf input.pdf

"C:\Program Files\gs\gs9.21\bin\gswin64c" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/screen -sOutputFile=output.pdf input.pdf

"C:\Program Files\gs\gs9.21\bin\gswin64c" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dDownsampleColorImages=true -dDownsampleGrayImages=true -dDownsampleMonoImages=true -dColorImageResolution=150 -dGrayImageResolution=150 -dMonoImageResolution=150 -dColorImageDownsampleThreshold=1.0 -dGrayImageDownsampleThreshold=1.0 -dMonoImageDownsampleThreshold=1.0 -o output-150.pdf input.pdf
```

### slicing up a large image into tiles

```sh
vips dzsave qianli.tif qianli --depth one --tile-size 1024 --overlap 128 --suffix .tif
```
