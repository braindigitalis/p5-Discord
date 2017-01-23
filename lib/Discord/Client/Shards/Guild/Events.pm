package Discord::Client::Shards::Guild::Events;

use Discord::Loader;
use Discord::Client::Shards::Guild::Message;
use Discord::Client::Shards::Guild::Message::User;

method on_message_create ($disc, $d) {
    my $base = $disc->base_name;
    if ($base->can('discord_message')) {
        my $message = Discord::Client::Shards::Guild::Message->new(
            edited_timestamp    => $d->{edited_timestamp},
            mention_roles       => $d->{mention_roles},
            channel_id          => $d->{channel_id},
            type                => $d->{type},
            tts                 => $d->{tts},
            author              => Discord::Client::Shards::Guild::Message::User->new(
                discriminator => $d->{author}->{discriminator},
                username      => $d->{author}->{username},
                avatar        => $d->{author}->{avatar},
                id            => $d->{author}->{id},
            ),
            nonce               => $d->{nonce},
            timestamp           => $d->{timestamp},
            content             => $d->{content},
            id                  => $d->{id},
            channel             => $disc->guild->find({ channel => $d->{channel_id}}),
        );

        # do we have mentions?
        if (scalar @{$d->{mentions}}) {
            $message->add_mentions($d->{mentions});
        }

        $base->discord_message($disc, $message);
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
        $guild->add_channels($d->{id}, $d);
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