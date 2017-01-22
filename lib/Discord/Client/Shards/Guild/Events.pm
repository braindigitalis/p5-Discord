package Discord::Client::Shards::Guild::Events;

use Discord::Loader;

with 'Discord::Client::Shards::Guild::Message';

method on_message_create ($disc, $d) {
    my $base = $disc->base_name;
    if ($base->can('discord_message')) {
        $base->discord_message($disc, $d);
    }
}

method on_guild_create ($disc, $d) {
    my $base = $disc->base_name;
    my $guild = $disc->guild->add({
        owner_id => $d->{owner_id},
        guild_id => $d->{id},
        name     => $d->{name},
        roles    => $d->{roles},
    });

    # create the channel and member objects
    if ($guild) {
        $guild->add_channels($d->{channels});
        $guild->add_members($d->{members});

        if ($base->can('discord_guild_create')) {
            $base->discord_guild_create($disc, $d->{id});
        }
    }
}

method handle_events ($disc, $type, $d) {
    # $self = Guild
    # $disc = Discord object
    # $type = Dispatch type
    # $d    = Data from payload

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