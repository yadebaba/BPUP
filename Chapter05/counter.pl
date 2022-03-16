#!/usr/bin/perl
die "USAGE: ./counter.pl infile outfile\n" if (@ARGV != 2);

# counting peptides in the file with a hash
open ($infile, "$ARGV[0]") || die "$!\n";
while ( my $pep = <$infile> ){
    chomp $pep;
    $counter{$pep}++;
}

# go through the hash and print it properly to a file
open ($outfile, "> $ARGV[1]") || die "$!\n";
foreach (sort { ($counter{$b} <=> $counter{$a}) ||
              ($b cmp $a) } keys %counter){
    printf $outfile "%7d %-s\n", $counter{$_}, $_;
} 