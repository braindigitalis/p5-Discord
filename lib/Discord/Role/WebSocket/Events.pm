package Discord::Role::WebSocket::Events;

use 5.010;
use Moo::Role;
use Mojo::IOLoop;
use Discord::OPCodes;
use Data::Dumper;

has 'heartbeat' => ( is => 'rw', default => sub {
	{
		check	 => 0,
		interval => 0,
		loop	 => undef,
	}
} );

sub on_hello {
	my ($self, $data) = @_;
	# sets the heartbeat interval retrieved from the hello packet
	$self->heartbeat->{interval} = $data->{d}->{heartbeat_interval};
	
	# send initial heartbeat
	$self->send_heartbeat;
	
	# create the loop that sends our heartbeat to the server
	$self->heartbeat->{loop} = Mojo::IOLoop->recurring($self->heartbeat->{interval},
        sub { $self->send_heartbeat; },
    );
}

sub on_receive {
	my ($self, $data) = @_;
    say Dumper($data) if $ENV{DISCORD_DEBUG};    
	# if we receive a sequence value, save it
	if ($data->{s}) {
		$self->seq($data->{s});
	}
}

sub on_cleanup {
	my ($self) = @_;
	# undefine the transaction attribute
	$self->tx(undef);
	
	# stop sending heartbeats
	Mojo::IOLoop->remove($self->heartbeat->{loop});
}

sub on_heartbeat_ack {
	my ($self, $data) = @_;
	$self->heartbeat->{check}--;
	say "-> Recieved heartbeat ack" if $ENV{DISCORD_DEBUG};;
}

sub on_ready {
    my ($self, $message) = @_;
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
                *{"Discord::Role::WebSocket::Session::User::${k}"} = sub {
                    return $user->{$k};
                };
            }
        }

        # remove the user key now we've stored it
        delete $message->{d}->{user};

        # now loop through the reset and store the data
        for my $k (keys %{$message->{d}}) {
            *{"Discord::Role::WebSocket::Session::${k}"} = sub {
                return $message->{d}->{$k};
            };
        }
    }
    
    my $base = $self->base_name;
    if ($base->can('discord_ready')) {
        $base->discord_ready($self, $message->{d});
    }
}

sub handle_events {
    my ($self, $message) = @_;
    # perl style switch/case to pass the events around
    # to their respective methods based on the op code from the server
    for ($message->{op}) {
        if ($_ == Discord::OPCodes::HELLO) { $self->on_hello($message); }
        if ($_ == Discord::OPCodes::HEARTBEAT_ACK) { $self->on_heartbeat_ack($message); }
        if ($_ == Discord::OPCodes::DISPATCH) { $self->handle_dispatch($message); }
    }
}

sub handle_dispatch {
    my ($self, $message) = @_;
    my $type = $message->{t};
    for ($type) {
        if ($_ eq 'READY') { $self->on_ready($message); }
    }
}

1;
__END__
