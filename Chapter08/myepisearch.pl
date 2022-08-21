#!/usr/bin/perl
use v5.10;
use Getopt::Long;
use List::Util qw( max min sum); 
use Array::Transpose;
help() if not @ARGV;
@residue = qw(A C D E F G H I K L M N P Q R S T V W Y);

my ($mimoseq, $pdbfile);
my $proberadius = 1.4;
my $asacutoff = 10;
my $atom = "CB";
my $patchradius = 12;
my $pd = 8.0;
my $scorecut = 0.5;

GetOptions ("mimoseq=s" => \$mimoseq,
            "pdbfile=s" => \$pdbfile,
            "asacutoff:f" => \$asacutoff,
            "atom:s" => \$atom,
            "scorecut:f" => \$scorecut,
            "help"  => \&help,			
            "version"  => \&version)
or die "\n";
		
# compute amino acid composition matrix of a mimotope file
my $seqmat = seq2mat ($mimoseq);

# compute surface using Surface Racer
`echo "1 $pdbfile $proberadius 1 n n" | ./sracer`;

# make residue filename ready
my $pdbid = substr $pdbfile, 0, 4;
my $resfile = $pdbid."_residue.txt";
# get surface residues
my $srlist = getsrlist($resfile, $asacutoff);

# get surface patches
my $atomfile = $pdbid.".txt";
my $xyz = getxyz ($atomfile, $srlist, $atom);
my $patches = findpatches($xyz, $patchradius);
# compute amino acid composition matrix of surface patches
my $patmat = pat2mat ($patches);

my $Xjk = getmatch($seqmat, $patmat);
my $SIMjk = normat($Xjk);
pickpat($SIMjk, $patches, $scorecut);


sub seq2mat{
	my $mimoseq = shift;
	my %seqmat;
	open(SEQ, $mimoseq) || die "Can't open $mimoseq. $!\n";
	while (<SEQ>){
		next if /^>/;
		next if /^\s*$/;
		my $seq = checkseq ($_);	
		my %freq = ();
		my @row = ();
		my @default = ('0') x 20;
		@freq{@residue} = (@default) x @residue;
		$freq{$1}++ while ($seq=~/(.)/g);
		push @row, $freq{$_} foreach (sort keys %freq);
		$seqmat{$seq}	= [@row];
	}
	close SEQ;
	return \%seqmat;
}

sub checkseq{
	my $seq = shift;
	die "Illegal residue!\n" if !/[ACDEFGHIKLMNPQRSTVWY\s\v]/;
	$seq =~ s/(\s|\v)+//g;
	chomp $seq;
	return $seq;
}

# collect surface residues
sub getsrlist{
	my ($resfile, $asacutoff) = @_;
	my %srlist;
	open(my $fh, $resfile) || die "Cannot open $resfile\n";
	while (my $line=<$fh>){
		my ($pos, $residue, $asa) = split /  /, $line;
		map {s/\s//g} ($pos, $residue, $asa);
		$srlist{$pos.$residue}++ if ($asa > $asacutoff);
	}
	close $fh;
	return \%srlist;
}

# collect coordinates of surface residues
sub getxyz{
	my ($atomfile, $srlist, $atom) = @_;
	
	my @xyz;
	my $TEMPLATE = join(
    '',	   #  index  columns     data type   field
    'a6',  #    0    1-6         string      Record name "ATOM"
    'a5',  #    1    7-11        integer     Atom serial number   
    'a1',  #    2    12   
    'a4',  #    3    13-16       string      Atom name
    'a1',  #    4    17          char        Alternate location indicator
    'a3',  #    5    18-20       string      Residue name 
    'a1',  #    6    21               
    'a1',  #    7    22          char        Chain identifier
    'a4',  #    8    23-26       integer     Residue sequence number
    'a1',  #    9    27          char        Code for insertion of residues
    'a3',  #    10   28-30
    'a8',  #    11   31-38       real        coordinates for X
    'a8',  #    12   39-46       real        coordinates for Y
    'a8',  #    13   47-54       real        coordinates for Z                         
    'a6',  #    14   55-60       real        van der Waals radius of atom
    'a1',  #    15   61                   
    'a7',  #    16   62-68       real        accessible surface area   
    'a7',  #    17   69-75       real        molecular surface area
    'a7',  #    18   76-82       real        average curvature of molecular surface     
    );

    open(my $fh, $atomfile) || die "Cannot open $atomfile\n";
    while (my $line = <$fh>){
		last if ($line !~ /^ATOM/);
		my @fields = unpack $TEMPLATE, $line;
		@fields = map {tr/ //dr} @fields;	 
		my $key = $fields[8].$fields[5];
		if ($srlist->{$key}) {
			if ($fields[5]=~/GLY/){
				push @xyz, [ $key, $fields[11], $fields[12], $fields[13] ] if ($fields[3] eq "CA");
			}else{
				push @xyz, [ $key, $fields[11], $fields[12], $fields[13] ] if ($fields[3] eq "$atom");
			}			
    	}
    }
    close $fh;
    return \@xyz;
}

# make the surface patches
sub findpatches{
	my ($xyz, $patchradius) = @_;
	my %patches;
	for my $resa (@$xyz){
		my @patch = ();
		for my $resb (@$xyz){
			my $dx = $resb->[1] - $resa->[1];
			my $dy = $resb->[2] - $resa->[2];
			my $dz = $resb->[3] - $resa->[3];
			my $dist = sqrt ($dx*$dx + $dy*$dy + $dz*$dz);
			if ( $dist <= $patchradius ){
				my $bpos = A321($resb->[0]);
				push @patch, $bpos; 
			}
		}
		my $apos = A321($resa->[0]);
		#say "$apos: [@patch]";
		$patches{$resa->[0]} = [@patch];	
	}
	return \%patches;
}

sub A321{
	my $posamino = shift;
	
	#hash for amino acid code converting
	my %AA123 = (
		A => 'ALA', V => 'VAL', L => 'LEU', I => 'ILE',
		P => 'PRO', W => 'TRP', F => 'PHE', M => 'MET',
		G => 'GLY', S => 'SER', T => 'THR', Y => 'TYR',
		C => 'CYS', N => 'ASN', Q => 'GLN', K => 'LYS',
		R => 'ARG', H => 'HIS', D => 'ASP', E => 'GLU',
	);
	my %AA321 = reverse %AA123;	
	
	$posamino =~ /(\d+)(\w+)/;
	return $AA321{$2}.$1;
}

sub pat2mat {
	my $patches = shift;
	my %patmat =();
	foreach my $patchid (sort {$a<=>$b} keys %{$patches}){
		my %freq = ();
		my @row =();
		my @default = ('0') x 20;
		@freq{@residue} = (@default) x @residue;
		foreach my $res (@{ $$patches{$patchid} }){
			$res =~/(\w)(\d+)/;
			$freq{$1}++;
		}
		push @row, $freq{$_} foreach (sort keys %freq);
		$patmat{$patchid} = [@row];
	}
	return \%patmat;
}

# get Xjk match number matrix 
sub getmatch{
	my ($seqmat, $patmat) = @_;
	my %match =();
	
	foreach my $pep (sort keys %$seqmat){
	my @pepcom = @{ $$seqmat{$pep} };
	my @row = ();
		foreach my $pat (sort {$a<=>$b} keys %$patmat){
			my @patcom = @{ $$patmat{$pat} };
			my $num = 0;

			for my $i (0..19){		
				if ($pepcom[$i]>0 and $patcom[$i] > 0 ){
					$num += getnumber($pepcom[$i], $patcom[$i]);
				}
			}
			push @row, $num;	
		}
		$match{$pep} = [@row];
	}
	return \%match;
}

# return match number
sub getnumber{
	my ($x, $y) = @_;
	#($x >= $y) ? return $y : return $x;
	return $x + $y;
}

#get normalized SIMjk matrix
sub normat{
	my $Xjk = shift;
	my %SIMjk =();
	
	foreach my $pep (sort keys %$Xjk){
		my @row = ();
		my @matnum = @{ $$Xjk{$pep} };
		my $min = min @matnum;
		my $max = max @matnum;
		foreach my $x (@matnum){
			my $normx = ($x - $min)/($max - $min);
			$normx = sprintf("%.3f", $normx);
			push @row, $normx;
		}
		$SIMjk{$pep} = [@row];
	}
	return 	\%SIMjk;
}

#pick patches with all SIMjk > $scorecut, 0.5 by default
sub pickpat{
	my ($SIMjk, $patches, $scorecut) = @_;

	my @AoA =();
	foreach my $pep (sort keys %$SIMjk){	
		push @AoA, $SIMjk->{$pep};
	}
	@AoA = transpose(\@AoA);

	my %iscore =();	
	for my $i (0..$#AoA){
		my $min = min @{$AoA[$i]};
		if ($min > $scorecut){
			my $suma = sum @{$AoA[$i]};
			my $score = sprintf("%.3f", $suma/@{$AoA[$i]});
			$iscore{$i} = $score;	
		}
	}
	
	my @pat = sort keys %$patches;
	foreach my $key (sort{$iscore{$b}<=>$iscore{$a}} keys %iscore){
		say $iscore{$key},"\t", $pat[$key], "\t", "@{$patches->{$pat[$key]}}";
	}
}


sub help{ die "USAGE: perl $0 -m mimoseq -p pdbfile\n"; }
sub version { die "$0 Version 0.1\n"; }
	