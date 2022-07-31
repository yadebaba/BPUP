#!/usr/bin/perl
use v5.10;
#play with substr
$course = "Bioinformatics Programming Using Perl";
say substr $course, 15;			# Programming Using Perl
say substr $course, -4;			# Perl
say substr $course, 15, 11;		# Programming
say substr $course, 3, -23;		# informatics
say substr $course, -4, 4, "R"; # Perl
say $course; 		# Bioinformatics Programming Using R
