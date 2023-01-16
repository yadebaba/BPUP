#!/usr/bin/perl
use v5.10;

$g = "Perl";
@g = qw(tom jerry);
%g = (H=>1, O=>18);
sub g {say "hello GLOB!";}
open ("g","poem.txt");

# typeglob is a special hash
say *g{SCALAR},"=>${*g{SCALAR}}";
say *g{ARRAY},"=>@{*g{ARRAY}}";
say *g{HASH},"=>",%{*g{HASH}};
say *g{CODE},"=>", &{*g{CODE}};
say *g{IO};
say *g{GLOB};
say *g{PACKAGE};
say *g{NAME};

# create an alias for all data types
*a = *g;
print while <a>;
