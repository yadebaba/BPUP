#!/usr/bin/perl
use v5.10;
die "USAGE: ./sorfinder.pl genbankfile start min max\n" if (@ARGV!=4);
# get command line parameters
my $file = shift;	# genome file in GenBank format
my $start = shift;	# the start codon
my $min = shift;	# minimum length of ORF 
my $max =shift;		# maximum length of ORF

# make the rule ready
my $rule = "$start(?:[ATGC]{3}(?<!TAG|TAA|TGA)){$min,$max}(?:TAG|TAA|TGA)";

# make genome sequence ready
my $genome = "";
open(my $fh, $file) ;
while (<$fh>){
	$genome.=$_ if (/^ORIGIN/../^\\\\/);
}
$genome = $genome =~tr/atgc//cdr;

# find potential ORFs on Watson strand
getORF ($genome, "Watson", $rule);
say "";
# find potential ORFs on Crick strand
my $complement = reverse ($genome =~tr/atgc/tacg/r);

getORF ($complement, "Crick", $rule);

sub getORF {
	my $genome = shift;
	my $chain = shift;
	my $rule = shift;
	while ( $genome =~ m/$rule/ig ){
		print "$chain\t @- - @+\t";
		say $&;
	}
	return ();
}
