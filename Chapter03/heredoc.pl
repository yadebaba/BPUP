#!/usr/bin/perl

# First Examples of here-doc
my $poem = <<"POEM";
    
    The coming of wisdom with time
        --- by William Butler Yeats
    
    Though leaves are many, the root is one;
    Through all the lying days of my youth.
    I swayed my leaves and flowers in the sun;
    Now I may wither into the truth!
    
    
POEM

# Second Example of here-doc
my $perl_poem = <<'PERLPOEM';
    The Perl Version of "the coming of wisdom with time"
                                     --- by Wayne Myers

    while ($leaves > 1) {
        $root = 1;
    }

    foreach($lyingdays{'myyouth'}) {
        sway($leaves, $flowers);
    }
    
    while ($i > $truth) {
        $i--;
    }
    
    sub sway {
        my ($leaves, $flowers) = @_;
        die unless $^O =~ /sun/i;
    }
PERLPOEM

print $poem, $perl_poem; 