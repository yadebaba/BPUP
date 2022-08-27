#!/usr/bin/perl -I ./lib
use v5.10;
use EpiSearch;
use Getopt::Long;

help() if not @ARGV;

my ($mimoseq, $pdbfile);
my $proberadius = 1.4;
my $asacutoff = 10;
my $atom = "CB";
my $patchradius = 12;
my $pd = 8.0;
my $scorecut = 0.5;

GetOptions ("mimoseq=s" => \$mimoseq,
            "pdbfile=s" => \$pdbfile,
            "asacutoff:f" => \$asacutoff,
            "atom:s" => \$atom,
            "scorecut:f" => \$scorecut,
            "help"  => \&help,			
            "version"  => \&version)
or die "\n";
		
# compute amino acid composition matrix of a mimotope file
my $seqmat = seq2mat ($mimoseq);

# compute surface using Surface Racer
`echo "1 $pdbfile $proberadius 1 n n" | ./sracer`;

# make residue filename ready
my $pdbid = substr $pdbfile, 0, 4;
my $resfile = $pdbid."_residue.txt";
# get surface residues
my $srlist = getsrlist($resfile, $asacutoff);

# get surface patches
my $atomfile = $pdbid.".txt";
my $xyz = getxyz ($atomfile, $srlist, $atom);
my $patches = findpatches($xyz, $patchradius);
# compute amino acid composition matrix of surface patches
my $patmat = pat2mat ($patches);

# get Xjk match number matrix
my $Xjk = getmatch($seqmat, $patmat);

#get normalized SIMjk matrix
my $SIMjk = normat($Xjk);

#pick patches with all SIMjk > $scorecut, 0.5 by default
my $results = pickpat($SIMjk, $patches, $scorecut);

#print the results
foreach my $row (@$results){
	say $row->[0],"\t",$row->[1],"\t", "@{$row->[2]}";
}

sub help{ die "USAGE: perl $0 -m mimoseq -p pdbfile\n"; }
sub version { die "$0 Version 0.2\n"; }