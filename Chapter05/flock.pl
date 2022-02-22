#!/usr/bin/perl
open POEM, "< poem.txt" || die "Can't open poem.txt: $!";
flock(POEM, 2) || die "Could not lock poem.txt: $!";
print scalar localtime,"\n";
print "The poem.txt is locked for reading by pid=$$.\n";
sleep 30;
flock(POEM, 8);
print scalar localtime,"\n";
print "The poem.txt is unlocked for reading by pid=$$.\n";
close POEM;
