package EpiSearch;
use Exporter;
use List::Util qw( max min sum); 
use Array::Transpose;
@ISA = qw (Exporter);
@EXPORT = qw ($TEMPLATE @residue seq2mat checkseq getsrlist getxyz findpatches A321 pat2mat getmatch getnumber normat pickpat);
@EXPORT_OK = qw (getmatch2);

$TEMPLATE = join(
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
@residue = qw(A C D E F G H I K L M N P Q R S T V W Y);

# compute amino acid composition matrix of a mimotope file
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
	my @results;
	my @pat = sort keys %$patches;
	foreach my $key (sort{$iscore{$b}<=>$iscore{$a}} keys %iscore){
		push @results, [$iscore{$key}, $pat[$key], $patches->{$pat[$key]}];
		#say $iscore{$key},"\t", $pat[$key], "\t", "@{$patches->{$pat[$key]}}";
	}
	return \@results;
}

sub getmatch2{
	my ($seqmat, $patmat) = @_;
	my %match =();
	
	foreach my $pep (sort keys %$seqmat){
	my @pepcom = @{ $$seqmat{$pep} };
	my @row = ();
		foreach my $pat (sort {$a<=>$b} keys %$patmat){
			my @patcom = @{ $$patmat{$pat} };
			my $num = 0;

			for my $i (0..19){
				if ($i == 0 || $i == 1 || $i == 3 || $i == 5 || $i == 10 || $i == 12 || $i == 18 || $i == 19){
					$num += getnumber($pepcom[$i], $patcom[$i]) if ($pepcom[$i]>0 and $patcom[$i] > 0 );
				}elsif ($i == 2 ){
					my $tmp = $patcom[2] + $patcom[11];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 4 ){
					my $tmp = $patcom[4] + $patcom[7];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 6 ){
					my $tmp = $patcom[6] + $patcom[13];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 7 ){
					my $tmp = $patcom[4] + $patcom[9] + $patcom[17];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 8 ){
					my $tmp = $patcom[8] + $patcom[14];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 9 ){
					my $tmp = $patcom[9] + $patcom[7];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 11 ){
					my $tmp = $patcom[11] + $patcom[4] + $patcom[15];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 13 ){
					my $tmp = $patcom[13] + $patcom[6];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 14 ){
					my $tmp = $patcom[14] + $patcom[8];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 15 ){
					my $tmp = $patcom[15] + $patcom[11] + $patcom[16];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}elsif ($i == 16 ){
					my $tmp = $patcom[16] + $patcom[15];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}else{ 
					my $tmp = $patcom[17] + $patcom[7];
					$num += getnumber($pepcom[$i], $tmp) if ($pepcom[$i]>0 and $tmp > 0 );
				}
			}
			push @row, $num;	
		}
		$match{$pep} = [@row];
	}
	return \%match;
}

1;	