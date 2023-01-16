#!/usr/bin/perl
use v5.10;
die "USAGE: ./pat2mat.pl 1e6j.pdb 1.4 10 CB 12\n" if not @ARGV;
my $pdbfile = shift;
my $proberadius = shift;
my $asacutoff = shift;
my $atom = shift;
my $patchradius = shift;

# compute surface using Surface Racer
`echo "1 $pdbfile $proberadius 1 n n" | ./sracer`;

# make residue filename ready
my $pdbid = substr $pdbfile, 0, 4;
my $resfile = $pdbid."_residue.txt";
# get surface residue list
my $srlist = getsrlist($resfile, $asacutoff);

# make atom filename ready
my $atomfile = $pdbid.".txt";
# get xyz of surface residues
my $xyz = getxyz ($atomfile, $srlist, $atom);

# make surface patches ready
my $patches = findpatches($xyz, $patchradius);

# print surface patches
say "Patch:\tResidues";
foreach my $patchid (sort {$a<=>$b} keys %{$patches}){
	say "$patchid:\t[@{ $$patches{$patchid} }]";
}

@residue = qw(A C D E F G H I K L M N P Q R S T V W Y);
say "\n";
pat2mat($patches);


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
		#my $apos = A321($resa->[0]);
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
	say "@residue";
	foreach my $patchid (sort {$a<=>$b} keys %{$patches}){
		my %freq = ();
		my @default = ('0') x 20;
		@freq{@residue} = (@default) x @residue;
		foreach my $res (@{ $$patches{$patchid} }){
			$res =~/(\w)(\d+)/;
			$freq{$1}++;
		}
		print "$freq{$_} " foreach (sort keys %freq);
		say "";
	}
}
