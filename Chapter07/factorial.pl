#!/usr/bin/perl
use v5.10;
#play with recursive subroutine
my $int=shift || die "./factorial.pl 5\n";
die "Need a small integer!\n" if ($int !~/\d\d?/);
say factorial($int);

sub factorial{
    my($x)= @_;
    return 1 if $x == 1;
    return($x * factorial($x-1));
}
