#!/usr/bin/perl
use v5.10;
help() if (@ARGV != 1 || $ARGV[0] !~ /\d+/);

# the array of eigen values
@lamda = (1961.504, 788.200, 539.776, 276.624, 244.106);
@residue = qw(A C D E F G H I K L M N P Q R S T V W Y);

# read physical–chemical properties into five hashes
while (<DATA>) {
	my @fields = split;
	$E1{$fields[0]} = $fields[1];
	$E2{$fields[0]} = $fields[2];	
	$E3{$fields[0]} = $fields[3];
	$E4{$fields[0]} = $fields[4];
	$E5{$fields[0]} = $fields[5];	
}

# compute property distances and save them in @AoA
# group similar residues and save them in %group
for my $resa (@residue){
	my @row = ();
	$group{$resa} = "";
	for my $resb (@residue){
		$de1 = $E1{$resa} - $E1{$resb};
		$de2 = $E2{$resa} - $E2{$resb};	
		$de3 = $E3{$resa} - $E3{$resb};	
		$de4 = $E4{$resa} - $E4{$resb};	
		$de5 = $E5{$resa} - $E5{$resb};
		$pd = sqrt($lamda[0]*$de1**2+$lamda[1]*$de2**2+
		$lamda[2]*$de3**2+$lamda[3]*$de4**2+$lamda[4]*$de5**2);
		$pd = sprintf("%.3f", $pd); 
		push @row, $pd;	
		if (($resb ne $resa) && ($pd < $ARGV[0])) {
			$group{$resa} .= $resb;
		}							
	}
	push @AOA, [@row];
}

showPDtable([@AOA], [@residue]);
say "\nSeq: Patch";
#print amino acid groups
foreach my $g (sort keys %group){
	say "$g  : $group{$g}";
}

# print property distance table
sub showPDtable{
	my ($AOA, $residue) = @_;
	print "\t";
	print "$_\t" foreach @$residue;
	say "";
	my $i = 0;
	foreach my $row (@$AOA){
		print "$residue->[$i]\t";
		print "$_\t" foreach @$row;
		say "";
		$i++;
	}
}

sub help{ die "USAGE: perl $0 8\n";}

__DATA__
A 0.008 0.134 -0.475 -0.039 0.181
R 0.171 -0.361 0.107 -0.258 -0.364
N 0.255 0.038 0.117 0.118 -0.055
D 0.303 -0.057 -0.014 0.225 0.156
C -0.132 0.174 0.070 0.565 -0.374
Q 0.149 -0.184 -0.030 0.035 -0.112
E 0.221 -0.280 -0.315 0.157 0.303
G 0.218 0.562 -0.024 0.018 0.106
H 0.023 -0.177 0.041 0.280 -0.021
I -0.353 0.071 -0.088 -0.195 -0.107
L -0.267 0.018 -0.265 -0.274 0.206
K 0.243 -0.339 -0.044 -0.325 -0.027
M -0.239 -0.141 -0.155 0.321 0.077
F -0.329 -0.023 0.072 -0.002 0.208
P 0.173 0.286 0.407 -0.215 0.384
S 0.199 0.238 -0.015 -0.068 -0.196
T 0.068 0.147 -0.015 -0.132 -0.274
W -0.296 -0.186 0.389 0.083 0.297
Y -0.141 -0.057 0.425 -0.096 -0.091
V -0.274 0.136 -0.187 -0.196 -0.299