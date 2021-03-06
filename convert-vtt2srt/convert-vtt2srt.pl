#!/usr/bin/perl -w

# Script to convert WebVTT files to SubRip SRT
# Usage: convert-vtt2srt.pl <filename.vtt>
# by @spenglertrb

use strict;
use warnings;

print "Usage: $0 <filename.vtt>\n" and exit if (!@ARGV);
my $src = $ARGV[0];

if (!-e $src) {
	print "Unable to find file: ${src}\n" and exit;
} else { 
	my ($path, $filename, $ext) = $src =~ /(.+)\/(.+)\.(vtt)$/;
	if (!defined $filename) {
		print "!\n"; exit(1); 
	}
	my $dst = "${path}/${filename}.srt";
	# load content from webvtt file
	open(my $info, "<:encoding(UTF-8)", $src) or die "Could not open ${src}: $!";
	
	my $count = 1;
	my $content = "";
	# check header, make sure we a dealing with webvtt
	if (scalar(<$info>) !~ /^\x{FEFF}WEBVTT/i) {
		print "Not a valid WebVTT file ${src}. Missing header!\n" and exit(1);
	}
	# loop though each line, and convert timestamps into srt type
	while (defined(my $line = <$info>)) {
		if ($line =~ /^(\d{2}\:\d{2}(\:\d{2})?)\.(\d{3}) --> (\d{2}\:\d{2}(\:\d{2})?)\.(\d{3})/) {
			my $time1 = (length($1) == 5) ? "00:$1" : $1;
			my $time2 = (length($4) == 5) ? "00:$4" : $4;

			# add UTF-8 BOM header to beginning of file
			$content .= chr(0xFEFF) if ($count == 1);
			$content .= "$count\n${time1},$3 --> ${time2},$6\n";
			$count++;
		} else {
			# add all text lines to output
			$content .= "$line" if ($count > 1);
		}
	}
	# save srt file with correct content
	open(my $fh, '>:encoding(UTF-8)', "${dst}") or die "Could not open file ${dst}' $!";
	print $fh $content;
	close $fh;
	print "Done! WebVTT converted to SRT successfully! Output: ${dst}\n";
}

