package Discord::Common::Throttler;

use Discord::Loader;
use Mojo::IOLoop;

has 'frequency' => ( is => 'rw' );
has 'limit'     => ( is => 'rw' );
has 'last_hit'  => ( is => 'rw', default => sub { time } );
has 'queue'     => ( is => 'rw', default => sub { {} } );

method queue_it ($cb) {
    $self->queue->{scalar($cb)} = $cb;
    my $id = Mojo::IOLoop->timer(($self->frequency*scalar(keys %{$self->queue})) => sub {
        $self->last_hit(time);
        delete $self->queue->{scalar($cb)};
        $cb->(@_);
    });
    Mojo::IOLoop->one_tick;
}

method apply ($cb) {
    my @caller = (caller(1));
    my $path   = $caller[3]; # Package::function

    # if we're sending shit too fast add it to the queue
    my $time = time;
    if (($time - $self->last_hit) < $self->frequency) {
        warn "[Trottled]: Adding $path to queue (" . ($time - $self->last_hit) . ")"
            if $ENV{DISCORD_DEBUG};
        $self->queue_it($cb);
    }
    else {
        $self->last_hit(time);
        $cb->(@_);
    }
}

1;
__END__
