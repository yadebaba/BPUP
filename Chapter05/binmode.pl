#!/usr/bin/perl

# Working with a binary file on Windows system
# the binmode call or :raw layer is necessary  

open IN, "brain.jpg" || die "$!\n";
open OUT, ">:raw", "brain1.jpg" || die "$!/n";
print OUT while <IN>;

open IN, "brain.jpg" || die "$!\n";
open OUT, ">", "brain2.jpg" || die "$!\n";
print OUT while <IN>;

open IN, "brain.jpg" || die "$!\n";
open OUT, ">", "brain3.jpg" || die "$!\n";
binmode OUT; select OUT;
print while <IN>;
