#!/usr/bin/perl

use v5.10;

say '-' x 14;
say '|   X-DEMO   |';
say '-' x 14;

# x in list context
@lines = ('-') x 14;	# create an array with 14 hyphens
@lines = ("=") x @lines;# convert each element to =

@residue = qw(A C D E F G H I K L M N P Q R S T V W Y);

# amino acids property scale taken from the AAIndex database
say "residue volume (Bigelow, 1967)";
@volume=(52.6,68.3,68.4,84.7,113.9,36.3,91.9,102.0,105.1,
102.0,97.7,75.7,73.6,89.7,109.1,54.9,71.2,85.1,135.4,116.2);

@aaindex{@residue} = (@volume) x @residue;
say "$_ => $aaindex{$_}" foreach sort keys %aaindex;
say @lines;