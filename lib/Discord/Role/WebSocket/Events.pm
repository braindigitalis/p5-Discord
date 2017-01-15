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
	$self->heartbeat->{interval} = $data->{d}->{heartbeat_interval};
	$self->heartbeat->{loop} = Mojo::IOLoop->recurring($self->heartbeat->{interval},
        sub {
            $self->heartbeat->{'check'}++;
            $self->_send($self, {
            	op => Discord::OPCodes::HEARTBEAT,
            	d  => $self->seq,
            });
        }
    );
}

sub on_receive {
	my ($self, $data) = @_;
	if ($data->{s}) {
		$self->seq($data->{s});
	}
}

sub on_cleanup {
	my ($self) = @_;
	Mojo::IOLoop->remove($self->heartbeat->{loop});
}

sub on_heartbeat_ack {
	my ($self, $data) = @_;
	$self->heartbeat->{check}--;
	say "Recieved heartbeat ack";
}

1;
__END__