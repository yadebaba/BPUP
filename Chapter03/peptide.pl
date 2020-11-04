#!/usr/bin/perl

use v5.10;

@residues = (
	'A',	# Ala	Alanine
	#'B',	# Asx	Aspartic acid or Asparagine
	'C',	# Cys	Cysteine
	'D',	# Asp	Aspartic acid
	'E',	# Glu	Glutamic acid
	'F',	# Phe	Phenylalanine
	'G',	# Gly	Glycine
	'H',	# His	Histidine
	'I',	# Ile	Isoleucine
	'K',	# Lys	Lysine
	'L',	# Leu	Leucine
	'M',	# Met	Methionine
	'N',	# Asn	Asparagine
	'P',	# Pro	Proline
	'Q',	# Gln	Glutamine
	'R',	# Arg	Arginine
	'S',	# Ser	Serine
	'T',	# Thr	Threonine
	'V',	# Val	Valine
	'W',	# Trp	Tryptophan
	#'X',	# Xxx	Unknown or any
	'Y',	# Tyr	Tyrosine
	#'Z',	# Glx	Glutamic acid or Glutamine
);
say @residues;
unshift @residues, 'B';
push @residues, qw(X Z);
say @residues;
say sort @residues;

$peptide = "SVSVGMKPSPRP";
say "\n$peptide";
@aminos = split //, $peptide;	# split with null pattern
say "@aminos"; 

foreach (0..$#aminos){
	$aminos[$_] = $aminos[$_].($_+1)."\n";
}
say @aminos; 
chomp @aminos;		# chomp foreach @aminos 
say "@aminos";
chop @aminos;		# foreach (@aminos){chop;} 
say "@aminos";
