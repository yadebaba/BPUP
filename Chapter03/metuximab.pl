#!/usr/bin/perl
use v5.10;

#hash for amino acid code converting
my %AA123 = (
	A => 'Ala', V => 'Val', L => 'Leu', I => 'Ile',
	P => 'Pro', W => 'Trp', F => 'Phe', M => 'Met',
	G => 'Gly', S => 'Ser', T => 'Thr', Y => 'Tyr',
	C => 'Cys', N => 'Asn', Q => 'Gln', K => 'Lys',
	R => 'Arg', H => 'His', D => 'Asp', E => 'Glu',
	);
my %AA321 = reverse %AA123;
my $comment_H = ">metuximab Heavy chain";
my $comment_L = ">metuximab Light chain";

my $heavy = <<'HEAVY';
Met Asn Phe Gly Leu Ser Trp Val Phe Ile Val Ile Leu Leu Lys Gly Val
Gln Ser Glu Val Lys Leu Glu Glu Ser Gly Gly Gly Leu Val Gln Pro Gly
Gly Ser Met Lys Leu Ser Cys Val Ala Ser Gly Phe Thr Phe Ser Asp Ala
Trp Met Asp Trp Val Arg Gln Ser Pro Glu Lys Gly Leu Glu Trp Val Ala
Glu Ile Arg Ser Ala Asn Asn His Ala Pro Tyr Tyr Tyr Thr Glu Ser Val
Lys Gly Arg Phe Thr Ile Ser Arg Asp Asp Ser Lys Ser Ile Ile Tyr Leu
Gln Met Asn Asn Leu Arg Ala Glu Asp Thr Gly Ile Tyr Tyr Cys Thr Arg
Asp Ser Thr Ala Thr His Trp Gly Gln Gly Thr Leu Val Thr Val Ser Ser
Ala Ser Thr Thr Ala Pro Ser Val
HEAVY

my $light = <<'LIGHT';
Met Asp Ser His Thr Gln Val Phe Ile Phe Leu Leu Leu Cys Val Ser Gly
Ala His Gly Ser Ile Val Met Thr Gln Thr Pro Thr Phe Leu Val Val Ser
Ala Gly Asp Arg Val Thr Ile Thr Cys Lys Ala Ser Gln Ser Val Ile Asn
Asp Val Ala Trp Tyr Gln Gln Lys Pro Gly Gln Ser Pro Lys Leu Leu Ile
Phe Tyr Ala Ser Asn Arg Asn Thr Gly Val Pro Asp Arg Phe Thr Gly Ser
Gly Tyr Gly Thr Asp Phe Thr Phe Thr Ile Ser Thr Val Gln Ala Glu Asp
Leu Ala Val Tyr Phe Cys Gln Gln Asp Tyr Ser Pro Pro Phe Thr Phe Gly
Ser Gly Thr Lys Leu Glu Ile Lys Arg Lys Ser Thr Ala Pro Thr Val Ser
LIGHT

my @harray = split /\s/, $heavy;
my @larray = split /\s/, $light;

foreach my $residue (@harray){
	$residue = $AA321{$residue};
}
foreach my $residue (@larray){
	$residue = $AA321{$residue};
}
say "$comment_H"; say @harray;
say "$comment_L\n", @larray;
