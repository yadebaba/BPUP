#!/usr/bin/perl
# Bird v1.0
while ( my $word = <STDIN>){
	chomp $word;
	if ($word eq "quit" || $word eq "bye"){
		last;
	}else{
		print "$word\n";
	}
}
