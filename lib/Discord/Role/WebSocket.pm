package Discord::Role::WebSocket;

use 5.010;
use Moo::Role;
use Discord::OPCodes;
use JSON::XS qw(encode_json decode_json);
use Compress::Zlib;
use Mojo::UserAgent;

with 'Discord::Role::WebSocket::Events';

has 'seq'	 => ( is => 'rw' );
has 'tx' 	 => ( is => 'rw' );

sub init_socket {
	my ($self) = @_;
	my $base = $self->base_name;
	my $url = $self->gateway_url .
        '?v=' . $self->api_version . '&encoding=' . $self->encoding;

    my $ua = Mojo::UserAgent->new;

    $ua->transactor->name('p5-Discord');
	$ua->websocket($url => sub {
            my ($ua, $tx) = @_;
    
            unless ($tx->is_websocket)
            {
            	$self->on_cleanup;
                return;
            }
    
            $self->tx($tx);
    		$self->identify;
    
            $tx->on(finish => sub {
                my ($tx, $code, $reason) = @_;
                if ($base->can('discord_close')) {
                	$base->discord_close($self, $tx, $code, $reason);
                }
            }); 
    
            # main loop
            $tx->on(message => sub {
                my ($tx, $json) = @_;
                my $message = decode_json($json);
                
                $self->on_receive($message);

                for ($message->{op}) {
                	if ($_ == Discord::OPCodes::HELLO) { $self->on_hello($message); }
                	if ($_ == Discord::OPCodes::HEARTBEAT_ACK) { $self->on_heartbeat_ack($message); }
                }

                if ($base->can('discord_read')) {
                	$base->discord_read($self, $message);
                }
            });        
        });

		Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}

sub _send {
	my ($self, $payload) = @_;
	my $enc_pay = encode_json($payload);
	$self->tx->send($enc_pay);
}

sub identify {
	my ($self) = @_;
	$self->_send({
		op => Discord::OPCodes::IDENTIFY,
		d  => {
		    "token" => $self->token,
		    "properties" => {
		        '$os'				=> $^O,
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
