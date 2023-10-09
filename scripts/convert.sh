mkdir -p resized
find . -name "*.png" -print0 | while read -d $'\0' file
do
  convert "$file" -resize 128x128 resized/"$file"
done

pushd resized
for f in *; do mv "$f" `echo $f | tr ' ' '_'`; done
popd

mkdir -p gallery
montage -mode concatenate -tile 8x8 -geometry 128x128+0+0 $(ls resized/*.png | head -64) gallery/gallery-small.png
montage -mode concatenate -tile 32x32 -geometry 128x128+0+0 $(ls resized/*.png | head -1024) gallery/gallery-large.png