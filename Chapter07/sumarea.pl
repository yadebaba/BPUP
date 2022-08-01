#!/usr/bin/perl
# Sum accessible surface area of atoms for each residue
use v5.10;
die "USAGE: ./sumasa.pl pdbid.txt residue.asa\n" if (@ARGV != 2);
open(IN, $ARGV[0]) or die "$!\n";

$TEMPLATE = join(
    '',	   #  index  columns     data type   field
    'a6',  #    0    1-6         string      Record name "ATOM"
    'a5',  #    1    7-11        integer     Atom serial number   
    'a1',  #    2    12   
    'a4',  #    3    13-16       string      Atom name
    'a1',  #    4    17          char        Alternate location indicator
    'a3',  #    5    18-20       string      Residue name 
    'a1',  #    6    21               
    'a1',  #    7    22          char        Chain identifier
    'a4',  #    8    23-26       integer     Residue sequence number
    'a1',  #    9    27          char        Code for insertion of residues
    'a3',  #    10   28-30
    'a8',  #    11   31-38       real        coordinates for X
    'a8',  #    12   39-46       real        coordinates for Y
    'a8',  #    13   47-54       real        coordinates for Z                         
    'a6',  #    14   55-60       real        van der Waals radius of atom
    'a1',  #    15   61                   
    'a7',  #    16   62-68       real        accessible surface area   
    'a7',  #    17   69-75       real        molecular surface area
    'a7',  #    18   76-82       real        average curvature of molecular surface     
    );
    
while ($line = <IN>){
	last if ($line !~ /^ATOM/);
	@fields = unpack $TEMPLATE, $line;
	$asa{$fields[8]."  ".$fields[5]} += $fields[16];
}

open (OUT, "> $ARGV[1]") or die "$!\n";
foreach $res(sort keys %asa){
	say OUT pack("A9A8", $res, sprintf("%8.2f", $asa{$res}));
} 
