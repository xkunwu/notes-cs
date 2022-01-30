SET fname=1
SET cu=0
SET cd=25
SET cl=0
SET cr=0
"C:\Users\xkunw\software\ffmpeg\bin\ffmpeg" -i "%fname%.mp4" -filter:v "crop=in_w-%cr%-%cl%:in_h-%cd%-%cu%:%cl%:%cu%" -c:a copy "%fname%-%cr%-%cd%-%cl%-%cu%.mp4"