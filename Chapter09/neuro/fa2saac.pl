#!/usr/bin/perl
use Bio::SeqIO;
use Bio::Seq;
use Bio::Tools::SeqWords;
die "perl $0 infile outfile label\n" if @ARGV !=3;

my $file="$ARGV[0]";	# input FASTA file
open (OUT, ">$ARGV[1]") or die "Can't open $ARGV[1]: $!\n"; 
my $label = $ARGV[2];	# 1 for positive, 0 for negative
my $amino="ACDEFGHIKLMNPQRSTVWY";
my @amino=split(//,$amino);

my $in = Bio::SeqIO->new(-file => "$file", 
                         -format => "fasta");
                         
while (my $seqobj = $in->next_seq()) {
	my $len=length($seqobj->seq());
	my $seq_word = Bio::Tools::SeqWords->new(-seq => $seqobj);
	my $hash = $seq_word->count_overlap_words(1);
   
	print OUT "$label\t";					# print class label
	for (my $i=0;$i<=$#amino;$i++){
		my $k=$amino[$i];
        my $q=sprintf "%.4f",$hash->{$k}/($len);
        print OUT $q."\t";	#print single amino acid composition
	}
	print OUT "\n";
}
