#!/usr/bin/perl
use v5.10;

open POEM, "< poem.txt" || die "$!";
flock(POEM, 2) || die "$!";
say scalar localtime;
say "The file poem.txt is locked for reading by pid=$$.";
sleep 20;
flock(POEM, 8) || die "$!";
say scalar localtime;
say "Now poem.txt is unlocked for reading by pid=$$.";
close POEM;
