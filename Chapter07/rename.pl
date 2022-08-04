#!/usr/bin/perl
die "USAGE: ./rename.pl dirpath oldext newext\n" if (@ARGV!=3);
mymv($ARGV[0],$ARGV[1],$ARGV[2]);

sub mymv {
    my ($dirpath,$oldext,$newext) = @_;

    return if not -d $dirpath;
    opendir (my $dh, $dirpath) or die "Can't open $dirpath: $!\n";
    while (my $sub = readdir $dh) {
        next if $sub eq '.' or $sub eq '..';
        my $old="$dirpath/$sub";
        my ($base, $ext) = split /\./, $old;
        if ($ext eq $oldext){
            my $new = $base.".$newext";
            `mv $old $new`;
            print "$old is renamed to $new\n";
        }
        mymv($old,$oldext,$newext);
    }
    close $dh;
    return;
} 
