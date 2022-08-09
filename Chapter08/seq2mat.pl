#!/usr/bin/perl
use v5.10;
my $file = shift ||
die "USAGE: ./seq2mat.pl mimotope\n"; 

@residue = qw(A C D E F G H I K L M N P Q R S T V W Y);
open(my $fh, $file) ;
my @mat;
while (<$fh>){
	next if /^>/;
	checkseq ($_);
	my $row = seq2mat ($_);
	push @mat, $row;
}

say "@residue";
foreach my $row ( @mat ){
	my %freq = %{$row};
	print "$freq{$_} " foreach (sort keys %freq);
	say "";	
}

sub seq2mat{
	my $seq = shift;
	my %freq;
	my @default = ('0') x 20;
	@freq{@residue} = (@default) x @residue;
	$freq{$1}++ while ($seq =~ /(.)/g);
	return \%freq;
}

sub checkseq{
	my $seq = shift;
	die "Illegal residue!\n" if !/[ACDEFGHIKLMNPQRSTVWY\s\v]/;
}
