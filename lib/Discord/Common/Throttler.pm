package Discord::Common::Throttler;

use Discord::Loader;
use Time::Piece;

has 'frequency' => ( is => 'rw' );
has 'limit'     => ( is => 'rw' );
has 'callers'   => ( is => 'rw', default => sub { {} } );

# callers = {
#    'Package::function' => {
#        'last_run' => TIMESTAMP,
#    },
#}


method apply ($cb) {
    my @caller = (caller(1));
    my $path   = $caller[3]; # Package::function

    # girl, we got history
    if (exists $self->callers->{$path}) {
        # get the last time it was ran
        my $last_run = $self->callers->{$path}->{last_run};
        my $hits     = $self->callers->{$path}->{hits};
    }
    else {
        $self->callers->{$path} = {
            last_run => localtime,
            hits     => 1,
        };
    }

    # finally issue the original callback if we haven't hit
    # the rate limit
    $cb->(@_);
}

1;
__END__
