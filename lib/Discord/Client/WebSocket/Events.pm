package Discord::Client::WebSocket::Events;

use Mojo::IOLoop;
use Discord::Loader as => 'Role';
use Discord::Constants::OPCodes;
use Data::Dumper;

has 'heartbeat' => ( is => 'rw', default => sub {
	{
		check	 => 0,
		interval => 0,
		loop	 => undef,
	}
} );

method on_hello ($data) {
	# sets the heartbeat interval retrieved from the hello packet
	$self->heartbeat->{interval} = $data->{d}->{heartbeat_interval}/1000;

	# send initial heartbeat
	$self->send_heartbeat;

	# create the loop that sends our heartbeat to the server
	$self->heartbeat->{loop} = Mojo::IOLoop->recurring($self->heartbeat->{interval},
        sub { $self->send_heartbeat; },
    );
}

method on_receive ($data) {
    say Dumper($data) if $ENV{DISCORD_DEBUG};
	# if we receive a sequence value, save it
	if ($data->{s}) {
		$self->seq($data->{s});
	}
}

method on_cleanup {
	# undefine the transaction attribute
	$self->tx(undef);

	# stop sending heartbeats
	Mojo::IOLoop->remove($self->heartbeat->{loop});
}

method on_heartbeat_ack ($data) {
	$self->heartbeat->{check}--;
	say "-> Recieved heartbeat ack" if $ENV{DISCORD_DEBUG};;
}

method on_ready ($message) {
    # the following part is just to make pulling out our user
    # information for the developer cleaner using chained methods
    # instead of gross hashes (ie: $discob->session->user->username)
    # we're modifying the package structure
    # so we need to do this in a no strict refs block
    {
        no strict 'refs';
        # pull out the user first
        my $user = $message->{d}->{user};
        for my $k (keys %$user) {
            if ($user->{$k}) {
                *{"Discord::Client::WebSocket::Session::User::${k}"} = sub {
                    return $user->{$k};
                };
            }
        }

        # remove the user key now we've stored it
        delete $message->{d}->{user};

        # now loop through the reset and store the data
        for my $k (keys %{$message->{d}}) {
            *{"Discord::Client::WebSocket::Session::${k}"} = sub {
                return $message->{d}->{$k};
            };
        }
    }

    my $base = $self->base_name;
    if ($base->can('discord_ready')) {
        $base->discord_ready($self, $message->{d});
    }
}

method handle_events ($message) {
    # perl style switch/case to pass the events around
    # to their respective methods based on the op code from the server
    for ($message->{op}) {
        if ($_ == Discord::Constants::OPCodes::HELLO) { $self->on_hello($message); }
        if ($_ == Discord::Constants::OPCodes::HEARTBEAT_ACK) { $self->on_heartbeat_ack($message); }
        if ($_ == Discord::Constants::OPCodes::DISPATCH) { $self->handle_dispatch($message); }
    }
}

method handle_dispatch ($message) {
    my $type = $message->{t};

    # if we have a channel_id, pass it to the Guild role to manage
    if (exists $message->{d}->{channel_id} or $message->{t} =~ /^GUILD_/) {
        # Discord::Client::Shards::Guild
        $self->guild->handle_events($self, $type, $message->{d});
    }

    for ($type) {
        if ($_ eq 'READY') { $self->on_ready($message); }
    }
}

1;
__END__
