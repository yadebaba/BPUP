#!/usr/bin/perl
use v5.10;

my $file = shift ||
die "Please provide a genome file in GenBank format!\n"; 

# make genome sequence ready
my $genome = "";
open(my $fh, $file) ;
while (<$fh>){
	$genome.=$_ if (/^ORIGIN/../^\\\\/);
}
$genome = $genome =~tr/atgc//cdr;

# find classic ORFs on Watson strand
while ($genome=~m/ATG(?:[ATGC]{3}(?<!TAG|TAA|TGA)){50,5000}(?:TAG|TAA|TGA)/ig){
	print "Watson\t @- - @+\t";
	say $&;	
}
say"";

# find classic ORFs on Crick strand
my $complement = reverse ($genome =~tr/atgc/tacg/r);
while ($complement=~m/ATG(?:[ATGC]{3}(?<!TAG|TAA|TGA)){50,5000}(?:TAG|TAA|TGA)/ig){
	print "Crick\t @- - @+\t";
	say $&;	
}
