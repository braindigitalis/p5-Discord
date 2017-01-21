package Discord::Common::Throttler;

use Discord::Loader;
use Mojo::IOLoop;

has 'frequency' => ( is => 'rw' );
has 'limit'     => ( is => 'rw' );
has 'last_hit'  => ( is => 'rw', default => sub { time } );
has 'queue'     => ( is => 'rw', default => sub { {} } );
has 'is_running' => ( is => 'rw', default => sub { 0 } );

method BUILD {
    my @sorted;

    # make sure we don't already have a loop running
    if (not $self->is_running) {
        # set as running so we don't accidentally
        # fire up another loop
        $self->is_running(1);

        # start the main loop and check for items in the queue
        Mojo::IOLoop->recurring(1, sub {
            if (keys %{$self->queue}) {
                # create an array from our queue and sort by time
                @sorted = sort { $a <=> $b } keys %{$self->queue};
                # grab the key of the next event we need to run
                my $next_key = $sorted[0];
                # now pull the callback from the queue based on the key
                my $next = delete $self->queue->{$next_key};
                # and run that shit
                $next->(@_);
            }
        });
    }
}

method apply ($cb) {
    my @caller = (caller(1));
    my $path   = $caller[3]; # Package::function
    my $sleep_for;
    # set the time for this callback
    # if one already exists, increment it
    my $time = time;
    $time = $time + 1
        if exists $self->queue->{time};

    # add it to the queue
    # the main loop will take care of the rest
    $self->queue->{$time} = $cb;
}

1;
__END__
