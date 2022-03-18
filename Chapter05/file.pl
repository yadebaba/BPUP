#!/usr/bin/perl
use v5.10;
use File::Copy;

rename "mimotope.txt", "mimotope.fa" or die $!;
move "mimotope.fa", "mimotope.seq" or die $!;
copy "mimotope.seq", "mimotope0.seq" or die $!;
say foreach <mimotope*>;
say unlink glob "*.seq";