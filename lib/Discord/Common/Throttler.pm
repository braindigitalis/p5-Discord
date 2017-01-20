package Discord::Common::Throttler;

use Discord::Loader;

has 'frequency' => ( is => 'rw' );
has 'limit'     => ( is => 'rw' );
has 'last_hit'  => ( is => 'rw', default => sub { time } );
has 'queue'     => ( is => 'rw', default => sub { {} } );

method apply ($cb) {
    my @caller = (caller(1));
    my $path   = $caller[3]; # Package::function
    my $sleep_for;

    # if we're sending shit too fast add it to the queue
    my $time = time;
    if (($time - $self->last_hit) < $self->frequency) {
        warn "[Trottled]: Adding $path to queue (" . ($time - $self->last_hit) . ")"
            if $ENV{DISCORD_DEBUG};
        $sleep_for = ($self->frequency - ($time - $self->last_hit));
        say "=> SLEEPING FOR $sleep_for"
            if $ENV{DISCORD_DEBUG};
        sleep $sleep_for;
        $self->last_hit(time);
        $cb->(@_);
    }
    else {
        $self->last_hit(time);
        $cb->(@_);
    }
}

1;
__END__
