package Library2;
use Moose;
 
has 'name' => (is => 'rw');
has 'length' => (isa => 'Int', is => 'rw');
has 'scheme' => (is => 'rw');

sub display{
	my $self = shift;
	print $self->name,"\t", $self->length,"\t", $self->scheme,"\n";
} 
1;