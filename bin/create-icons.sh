#!/usr/bin/env bash
echo 'Create app icons'
mkdir app/img/icon.iconset
sips -z 16 16     app/img/icon.png --out app/img/icon.iconset/icon_16x16.png
sips -z 32 32     app/img/icon.png --out app/img/icon.iconset/icon_16x16@2x.png
sips -z 32 32     app/img/icon.png --out app/img/icon.iconset/icon_32x32.png
sips -z 64 64     app/img/icon.png --out app/img/icon.iconset/icon_32x32@2x.png
sips -z 128 128   app/img/icon.png --out app/img/icon.iconset/icon_128x128.png
sips -z 256 256   app/img/icon.png --out app/img/icon.iconset/icon_128x128@2x.png
sips -z 256 256   app/img/icon.png --out app/img/icon.iconset/icon_256x256.png
sips -z 512 512   app/img/icon.png --out app/img/icon.iconset/icon_256x256@2x.png
sips -z 512 512   app/img/icon.png --out app/img/icon.iconset/icon_512x512.png

cp app/img/icon.png app/img/icon.iconset/icon_512x512@2x.png
cp app/img/icon.png app/img/icon.iconset/icon_1024x1024.png
iconutil -c icns app/img/icon.iconset
rm -R app/img/icon.iconset

convert app/img/icon-default.png -filter triangle -resize 22x app/img/tray-icon-default.png
convert app/img/icon-default.png -filter triangle -resize 44x app/img/tray-icon-default2x.png
convert app/img/icon-ok.png      -filter triangle -resize 22x app/img/tray-icon-ok.png
convert app/img/icon-ok.png      -filter triangle -resize 44x app/img/tray-icon-ok2x.png
convert app/img/icon-error.png   -filter triangle -resize 22x app/img/tray-icon-error.png
convert app/img/icon-error.png   -filter triangle -resize 44x app/img/tray-icon-error2x.png
echo 'App icons created'