package Discord::Client::Shards::Guild;

use 5.010;
use Moo;

sub on_message_create {
    my ($self, $disc, $d) = @_;
    my $base = $disc->base_name;
    if ($base->can('discord_message')) {
        $base->discord_message($disc, $d);
    }
}

sub handle_events {
    # $self = Guild
    # $disc = Discord object
    # $type = Dispatch type
    # $d    = Data from payload
    my ($self, $disc, $type, $d) = @_;

    # lowercase the event name, and append on_
    my $method = lc "on_$type";

    # finally check to see if we have a call for it
    # and then pass the data object to it
    if ($self->can($method)) {
        $self->$method($disc, $d);
    }
}

1;
__END__
