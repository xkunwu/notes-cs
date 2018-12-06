---
---
### Batch reduce image size

```
for file in *.jpg; do convert -resize 25% $file $file; done
```

### Reduce video size
```
ffmpeg -i input.mp4 -vcodec libx264 -crf 24 -an output.mp4
```

### Convert to gif
```
ffmpeg -i CenterPiece.mp4  -r 10 CenterPiece.gif
convert -loop 0 frames/*.png output.gif
```
