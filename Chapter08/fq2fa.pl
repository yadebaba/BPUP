#!/usr/bin/perl
use Getopt::Long;
help() if not @ARGV;

my $infile; my $outfile;
GetOptions ("infile=s" => \$infile,			# string
            "outfile=s"   => \$outfile,		# string
            "help"  => \&help,			
            "version"  => \&version);		
open (my $fq, $infile); 
open (my $fa, ">$outfile") ; 
while (1) {
    my $line1 = <$fq>; last unless defined $line1;
	print $fa ">".$line1;
    my $line2 = <$fq>; last unless defined $line2;
	print $fa $line2;
	
    my $line3 = <$fq>; last unless defined $line3;
    my $line4 = <$fq>; last unless defined $line4;
}
sub help{ die "USAGE: perl $0 -i infile -o outfile\n"; }
sub version { die "$0 Version 1.0\n"; }
