package Discord::Client::Shards::Guild;

use 5.010;
use Moo;
use Discord::Helper;

method on_message_create ($disc, $d) {
    my $base = $disc->base_name;
    if ($base->can('discord_message')) {
        $base->discord_message($disc, $d);
    }
}

method handle_events ($disc, $type, $d)
{
    # $self = Guild
    # $disc = Discord object
    # $type = Dispatch type
    # $d    = Data from payload
    #my ($self, $disc, $type, $d) = @_;

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
