package Library;
sub new {
	my $class = shift;
	my ($name, $length, $codescheme)= @_;
	my $ref = {					
		Name =>$name,
		Length => $length,
		CodeScheme => $codescheme,
	};
	bless $ref, $class;
	return $ref;
}

sub set_data{
	my $self = shift;
	$self->{Name}=shift;
	$self->{Length}=shift;	
	$self->{CodeScheme}=shift;
}

sub display{
	my $self = shift;
	my @args = @_;
		
	foreach my $field (@args){
		print $self->{$field}, "\t";
	}
	print "\n";
}

1;