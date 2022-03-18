#!/usr/bin/perl
use v5.10;

say 5, 2, 0, 1, 3, 1, 4;
say A..Z;

$, =" "; # set a space to $, the output field separator
say ('Bioinformatics', 'Programming', 'Using', 'Perl');

say "\nIUB/IUPAC one letter codes for amino acids:";
say qw(A B C D E F G H I K L M N P Q R S T V W X Y Z);
