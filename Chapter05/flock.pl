#!/usr/bin/perl
use v5.10;

open POEM, "< poem.txt" || die "$!\n";
flock(POEM, 2) || die "$!\n";
say scalar localtime;
say "The file poem.txt is locked for reading by pid=$$.";
sleep 20;
flock(POEM, 8) || die "$!\n";
say scalar localtime;
say "Now poem.txt is unlocked for reading by pid=$$.";
close POEM;
