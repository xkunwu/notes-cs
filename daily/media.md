# batch reduce image size

```
for file in *.jpg; do convert -resize 25% $file $file; done
```

# reduce video size
```
ffmpeg -i input.mp4 -vcodec libx264 -crf 24 -an output.mp4
```
