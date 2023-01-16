#!/usr/bin/perl

use v5.10;

my $hla = 'not defined';
if ("serum"){
	my $hla = 'HLA-A2';
	say "In the serum scope, my \$hla is $hla";
	if ("allele"){
		my $hla = 'HLA-A*02:01';
		say "In the allele scope, my \$hla is $hla";
	}
}
say "In the file scope, my \$hla is $hla.\n";

our $taxonomy = 'mammal';
say "Our \$taxonomy = $taxonomy";
if ("species"){
	$taxonomy = 'homo sapiens';
	say "In species scope, our \$taxonomy = $taxonomy";
}
say "Our \$taxonomy has changed to $taxonomy wherever.\n";

our $species = 'homo sapiens';

{ # my block
  my $species = 'homo deus';
  say "In my block, my \$species = $species";
  say "In my block, \$::species = $::species";
}

{ # local block
  local $species = 'homo deus';
  say "In local block, local \$species = $species";
  say "In local block, \$::species = $::species";
}

say "Outside blocks, our \$species = $species";
say "Outside blocks, \$::species = $main::species";
