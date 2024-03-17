#!/usr/bin/env bash

# point these vars at a nice flac source
FLAC_SOURCE="/media/album/02 cool_song.flac"
IMG="/media/album/folder.jpg"
SNIPPET_START="00:02:00" # hr:min:sec
SNIPPET_DURATION=20 # seconds
OUTPUT_MKV="output.mkv"

# Create a flac snippet to make it easier to re-encode.
TEMP_DIR=$(mktemp -d)
FLACSNIP="$TEMP_DIR/main_snippet.flac"
ffmpeg -i "$FLAC_SOURCE" -vn -ss "$SNIPPET_START" -t $SNIPPET_DURATION "$FLACSNIP"

# Place additional encodings to compare here. Ensure the resulting file ends up in TEMP_DIR.
###
ffmpeg -i "$FLACSNIP" -vn -c:a aac -b:a "256k" -strict -2 "$TEMP_DIR/snippet.m4a"
#opusenc uses per channel bitrate, unlike ffmpeg
opusenc --bitrate 256 "$FLACSNIP" "$TEMP_DIR/snippet_256.opus"
opusenc --bitrate 64 "$FLACSNIP" "$TEMP_DIR/snippet_64.opus"
###

# Create input and map flags for each snippet in TEMP_DIR
COUNT=1
for snippet in "$TEMP_DIR"/*; do
    [ -e "$snippet" ] || continue

    INPUT_OPTS+=" -i $snippet"
    MAP_OPTS+=" -map $COUNT:a:0"
    ((COUNT++))
done

# Mux together each audio stream.
ffmpeg -loop 1 \
    -i "$IMG" \
    $INPUT_OPTS \
    -c:v libx264 -tune stillimage \
    -c:a copy -shortest \
    -map 0:v:0 \
    $MAP_OPTS \
    -f matroska "$OUTPUT_MKV"

rm -r "$TEMP_DIR"
