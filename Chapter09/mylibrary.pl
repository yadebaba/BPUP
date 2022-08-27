#!/usr/bin/perl -I ./lib
use Library;
my $lib1 = Library->new();
$lib1->set_data("PhD12","12","NNK");
$lib1->display("Name","Length","CodeScheme");

my $lib2 = new Library ("f88-LX6","10","NNM");
$lib2->display("Name","Length","CodeScheme");