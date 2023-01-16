#!/usr/bin/perl
use v5.10;
use File::Copy;

copy "mimotope1.fa", "mimotope1.seq" or die "$!\n";
rename "mimotope1.seq", "mimotope.seq" or die "$!\n";
move "mimotope.seq", "mimotope0.seq" or die "$!\n";
copy "mimotope0.seq", "mimotope2.seq" or die "$!\n";
say foreach <mimotope*>;
say unlink glob "*.seq";