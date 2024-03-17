# bitscare

## Requirements

ffmpeg, and opus-tools(specifically opusenc) must be installed.

WOMM

## Usage

Create a SNIPPET_DURATION seconds long matroska file with many audio streams inside.

First modify the first few lines to point to your flac source and cover art (or comment the img stuff out) because I'm not going to modify this to take args rn.

`./bitscare.sh`

Play the _output.mkv_ in something that easily lets you switch between audio streams ex. `mpv`.

If you're interested in more encodings as long as they end up in TEMP_DIR they should get muxed.