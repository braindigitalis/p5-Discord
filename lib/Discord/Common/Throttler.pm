package Discord::Common::Throttler;

use Discord::Loader;
use Mojo::IOLoop;

has 'frequency' => ( is => 'rw' );
has 'limit'     => ( is => 'rw' );
has 'last_hit'  => ( is => 'rw', default => sub { time } );
has 'queue'     => ( is => 'rw', default => sub { {} } );

method BUILD {
    my @sorted;
    Mojo::IOLoop->recurring(1, sub {
        if (keys %{$self->queue}) {
            @sorted = sort { $a <=> $b } keys %{$self->queue};
            my $next_key = $sorted[0];
            my $next = delete $self->queue->{$next_key};
            $next->(@_);
        }
    });
}

method apply ($cb) {
    my @caller = (caller(1));
    my $path   = $caller[3]; # Package::function
    my $sleep_for;
    my $time = time;
    $time = $time + 1
        if exists $self->queue->{time};

    $self->queue->{$time} = $cb;
    # if we're sending shit too fast add it to the queue
    #my $time = time;
    #if (($time - $self->last_hit) < $self->frequency) {
    #    warn "[Trottled]: Adding $path to queue (" . ($time - $self->last_hit) . ")"
    #        if $ENV{DISCORD_DEBUG};
    #    $sleep_for = ($self->frequency - ($time - $self->last_hit));
    #    say "=> SLEEPING FOR $sleep_for"
    #        if $ENV{DISCORD_DEBUG};
    #    sleep $sleep_for;
    #    $self->last_hit(time);
    #    $cb->(@_);
    #}
    #else {
    #    $self->last_hit(time);
    #    $cb->(@_);
   # }
}

1;
__END__
