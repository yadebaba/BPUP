#!/usr/bin/perl
use v5.10;

# open and print a poem of Yeats 
open POEM, "poem.txt" || die "Can't open poem.txt: $!";
print while <POEM>;
close POEM;

# check the fasta files in current directory
say "\n\nFasta files in current directory:";
say $_ foreach (<*.fa>);
say "Sequences inside are extracted to mimotope.txt";

# glob all fasta filenames into an array
my @files = glob("*.fa");

my $mode;
if (-T "mimotope.txt"){$mode = ">>";}else{$mode = ">";}

open (my $fh, "$mode", "mimotope.txt") || 
    die ("can't open mimotope.txt: $!");
foreach my $file (@files){
	if (open (FH, "<","$file")) {
		while (<FH>){say $fh $_ if ($_!~/^>/);}
	}else{
		warn "Can't open $file: $!";
	}
	close FH;	
}
close $fh;
