#/bin/sh
FILE_NAME=${1:-untitled}
VIDEO_LENGTH=24

## upload files to the server
#scp {render_bg.sh,*.blend} palau:projects/blob_fish

## render frames
blender --background ${FILE_NAME}.blend --render-output //render/anim_####.png --engine CYCLES -s 0 -e ${VIDEO_LENGTH} -a
#blender --background ${FILE_NAME}.blend --render-output //render/frame_ --engine CYCLES -f 0

## copy reverse frames
#python -c "for i in range(${VIDEO_LENGTH}): print('{0:04} --> {1:04}'.format(i, 2*${VIDEO_LENGTH}-i))"
python - <<EOF
import shutil
for i in range(1,${VIDEO_LENGTH}): shutil.copy2('./render/anim_{0:04}.png'.format(i),'./render/anim_{0:04}.png'.format(2*${VIDEO_LENGTH}-i))
EOF

## convert to a video
ffmpeg -y -i ./render/anim_%04d.png -vcodec libx264 -crf 18 -preset veryslow -framerate 10 ./render/output.mp4
#ffmpeg -y -i ./render/anim_%04d.png -vcodec png -pix_fmt argb -crf 18 -preset veryslow -framerate 10 ./render/output.mp4

## syncronize from server
#rsync -auvh -e ssh palau:projects/blob_fish/render ./
