#!/usr/bin/perl
my @aa = qw(C D E F G H I K L M N P Q R S T V W Y A);
my @pep = qw(A A A A A A A A A);

print @pep, "\n";
 
for ( my $i = 0; $i <= 8; $i++ ) {
	foreach my $res (@aa){
		$pep[$i] = $res;
		if ($res ne 'A'){
			print @pep;
		}
		print "\n";
	}
}
