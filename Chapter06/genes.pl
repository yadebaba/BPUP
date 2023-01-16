#!/usr/bin/perl
#list all genes in a genome
my $file = shift ||
die "Please provide a genome file in GenBank format!\n"; 

open(my $fh, $file) ;
while (<$fh>){
    print if (/^     gene/../GeneID:\d+"$/);
}
