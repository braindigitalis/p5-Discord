package Discord::Role::WebSocket;

use Moo::Role;
use Discord::OPCodes;
use JSON::XS qw(encode_json decode_json);
use POE qw(Component::Client::WebSocket);
use Compress::Zlib;

has 'heap' => ( is => 'rw' );
has 'sender' => ( is => 'rw' );
has 'kernel' => ( is => 'rw' );

sub init_socket {
	my ($self) = @_;
	my $base = $self->base_name;
	my $url = $self->gateway_url .
        '?v=' . $self->api_version . '&encoding=' . $self->encoding;

	POE::Session->create(
	    inline_states => {
	        _start => sub {
	            my $ws = POE::Component::Client::WebSocket->new($url);
	            $ws->handler('connected','connected');
	            $ws->connect;
	 
	            $_[HEAP]->{ws} = $ws;
	            $self->sender($_[SENDER]);
	            $self->kernel($_[KERNEL]);
                $self->heap($ws);

	            $_[KERNEL]->yield("next")
	        },
	        next   => sub {
	            $_[KERNEL]->delay(next => 1);
	        },
	        websocket_read => sub {
	            my ($kernel,$read) = @_[KERNEL,ARG0];
	            if ($base->can('discord_read')) {
	            	$base->discord_read($self, $read);
	            }
	       },
	       websocket_disconnected => sub {
	            if ($base->can('discord_close')) {
	            	$base->discord_close($self);
	            }
	       },
	       connected => sub {
	            my $req = $_[ARG0];
	            if ($base->can('discord_init')) {
	            	$base->discord_init($self, $req);
	            }
	       },
	       websocket_handshake => sub {
	            my $res = $_[ARG0];
	 
	          	$self->identify;
	       },
	    },
	);
	 
	POE::Kernel->run();
}

sub _send {
	my ($self, $payload) = @_;
	my $enc_pay = encode_json($payload);
	$self->kernel->post($self->sender->ID, 'send', $enc_pay);
	$self->heap->send($enc_pay);
}

sub identify {
	my ($self) = @_;
	$self->_send({
		op => Discord::OPCodes::IDENTIFY,
		d  => {
		    "token" => $self->token,
		    "properties" => {
		        '$os'				=> "linux",
		        '$browser'			=> "p5-Discord",
		        '$device'			=> "p5-Discord",
		        '$referrer'			=> "",
		        '$referring_domain'	=> ""
		    },
		    "compress" => 1,
		    "large_threshold" => 250,
		    "shard" => [$self->shards]
		},
	});
}

1;
__END__
