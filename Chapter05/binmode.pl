#!/usr/bin/perl

# Working with a binary file on Windows system
# the binmode call or :raw layer is necessary  

open IN, "brain.jpg" || die $!;
open OUT, ">:raw", "brain1.jpg" || die $!;
print OUT while <IN>;

open IN, "brain.jpg" || die $!;
open OUT, ">", "brain2.jpg" || die $!;
print OUT while <IN>;

open IN, "brain.jpg" || die $";
open OUT, ">", "brain3.jpg" || die $!;
binmode OUT; select OUT;
print while <IN>;
