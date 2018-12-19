# gifts-of-perl

# convert-vtt2srt.pl
First public code release. Script converts a WebVTT file to a SubRip SRT file.
Simple and easy to use. 

Takes the full path of a file as argument, and will output a converted version
of the file to the source path. The script will check for a valid WebVTT header, before
converting.

I needed this in a workflow to feed a transcoder with did not support WebVTT natively.
