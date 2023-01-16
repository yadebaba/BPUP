#!/usr/bin/perl -I ./lib
use Library2;

my $lib1 = Library2->new(name=>'PhD12', length=>'12', scheme=>'NNK');
$lib1->display;

my $lib2 = new Library2;
# $lib2->length('ten');
