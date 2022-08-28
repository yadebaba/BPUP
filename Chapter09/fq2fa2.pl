#!/usr/bin/perl
help() if @ARGV != 2;
         
use Bio::SeqIO;            	
my $in = Bio::SeqIO->new(-file => "<$ARGV[0]",
                         -format => "fastq"); 
my $out = Bio::SeqIO->new(-file => ">$ARGV[1]",
                         -format => "fasta");   
while(my $seq = $in->next_seq()){
  $out -> write_seq($seq);
}         
sub help{ die "USAGE: perl $0 infile outfile\n"; }