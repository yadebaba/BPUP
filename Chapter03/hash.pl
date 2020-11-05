#!/usr/bin/perl

use v5.10;

%bases = ("0", "A", "1", "T", "2", "G", "3", "C", "15", "N",);
say %bases;
@bases = %bases;	#unwinding
say "@bases";

#hash for amino acid code converting
my %AA123 = (
	A => 'Ala', V => 'Val', L => 'Leu', I => 'Ile', 
	P => 'Pro', W => 'Trp', F => 'Phe', M => 'Met',
	G => 'Gly', S => 'Ser', T => 'Thr', Y => 'Tyr',
	C => 'Cys', N => 'Asn', Q => 'Gln', K => 'Lys',
	R => 'Arg', H => 'His', D => 'Asp', E => 'Glu',
	);
$AA123{B} = 'Asx'; $AA123{X} = 'Xxx'; $AA123{Z} = 'Glx';

#built in functions frequently used for hashes
say "\n", keys %AA123;
@triplet = values %AA123;
say "@triplet";

foreach (sort keys %AA123){
	say "$_ => $AA123{$_}";
}

%AA321 = reverse %AA123;	# swap key and value
delete $AA321{Xxx}; 		# delete the key and the value
$AA321{Asx}=''; 			# now the value eq ''(empty string)
undef $AA321{Glx};			# now the value is undef

say "";
while( ($key, $value) = each %AA321){
  say "$key => $value" if $value;
}

if (exists $AA321{Glx}){
	say "The key Glx exists, but with undef value.";
}