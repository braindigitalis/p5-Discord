package Discord::Role::WebSocket::Events;

use 5.010;
use Moo::Role;
use Mojo::IOLoop;
use Discord::OPCodes;

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

sub handle_events {
    my ($self, $message) = @_;
    # perl style switch/case to pass the events around
    # to their respective methods based on the op code from the server
    for ($message->{op}) {
        if ($_ == Discord::OPCodes::HELLO) { $self->on_hello($message); }
        if ($_ == Discord::OPCodes::HEARTBEAT_ACK) { $self->on_heartbeat_ack($message); }
    }
}

1;
__END__