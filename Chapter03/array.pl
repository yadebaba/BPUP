#!/usr/bin/perl

use v5.10;

# create, assign and print lists and arrays
@dna = ($a, $t, $g, $c) = qw (A T G C);
say @dna;
say "|"x4; # a visual way of pairing
# making base pairing by swap
($a, $t, $g, $c) = ($t, $a, $c, $g); 
say $a, $t, $g, $c;

@bases = @dna;	# assign the list in @dna to @bases
$type = @bases;	# array in scalar context, return its length
say "There are $type types of bases in DNA: @dna.";
$u = (1, U);	# list in scalar context, return last one
say "$u(racil) rather than T(hymine) is used in RNA.\n"; 

# accessing an element or elements of an array or list
say qw (A B U G)[1,2,3];		# list with subscript
$bases[15] ='N';				# not @bases[15]!
# say @bases;					# $bases[4] ... undef 
@dna[0,1,2,3]=@dna[1,0,3,2];	# swap via subscript
$" = "-";  say "@dna";
@dna = @bases[0..3];			# assignment via subscript 
say"@dna";						# I will be back!
# both $#dna and -1 get the index of last element in @dna
say "The last base in \@dna is $dna[$#dna]ytosine ($dna[-1]).\n"; 

# go through a LIST or an array using foreach loop
say "Go through \@bases and print defined elements.";
foreach $base (@bases){			# go through @bases
	print $base if $base;		# skip undef elements
}
say "";							# echo an empty line
foreach $index (0..$#bases){	# go through the list
	say "$index => $bases[$index]" if $bases[$index];
}

say "";
# Functions often used for lists and arrays
splice @bases, 4, 11, qw(U M R W S Y K V H D B);
say "New bases:\t", @bases;
say "shift bases:\t", shift @bases;
say "pop bases:\t", pop @bases;
say "after reverse:\t", reverse @bases;
say "after sort:\t", sort @bases;
splice @bases;							# @bases =();
say "Now \@bases has ", scalar @bases, " element.\n";
