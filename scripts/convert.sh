#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# rm -Rf "$DIR/../images/resized"
# rm -Rf "$DIR/../images/gallery"
# mkdir -p "$DIR/../images/resized"
# mkdir -p "$DIR/../images/gallery"

# find "$DIR/../images/" -name "*.png" -print0 | while read -d $'\0' file
# do
#   file_name=$(basename "$file")
#   convert "$DIR/../images/$file_name" -resize 128x128 "$DIR/../images/resized/$file_name"
# done

# pushd "$DIR/../images/resized"
# for f in *; do mv "$f" `echo $f | tr ' ' '_'`; done
# popd

montage -mode concatenate -tile 8x8 -geometry 128x128+0+0 $(ls "$DIR/../images/resized/"*.png | head -64) "$DIR/../images/gallery/gallery-small.png"
montage -mode concatenate -tile 32x32 -geometry 128x128+0+0 $(ls "$DIR/../images/resized/"*.png | head -1024) "$DIR/../images/gallery/gallery-large.png"

./basisu -ktx2 -mipmap "$DIR/../images/gallery/gallery-large.png" -output_path "$DIR/../images/gallery/"