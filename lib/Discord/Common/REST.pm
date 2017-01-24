package Discord::Common::REST;

use Discord::Loader as => 'Role';
use URI::Escape qw/uri_escape uri_escape_utf8 uri_unescape/;

has 'ua' => ( is => 'rw', default => sub { Mojo::UserAgent->new } );

method init_gateway {
	my $ua = $self->ua;

	$ua->on(start => sub {
        my ($ua, $tx) = @_;
        my $tok = $self->token;
        if ($self->bot) { $tok = "Bot ${tok}"; }
        $tx->req->headers->authorization($tok);
    });

    $ua->transactor->name('p5-Discord');
    $ua->inactivity_timeout(110);
    $ua->connect_timeout(10);

    $self->set_gateway_url();
}

method set_gateway_url {
	my $res = $self->get($self->api_url);

    if ($res and $res->{url}) {
        $self->gateway_url($res->{url});
        if ($res->{shards}) {
            $self->shards($res->{shards});
        }
    }
    else {
        die "Failed to retrieve gateway URL: $res->{message}\n";
    }
}

method get ($url, $content) {
    my $ua = $self->ua;
    if ($content) {
    	$url = "${url}?" . $self->_build_params($content);
    }
    my $tx = $ua->get($url);
    return $tx->res->json;
}

method post ($url, $content) {
	my $ua = $self->ua;
	$ua->post($url => json => $content => func {
		my ($ua, $tx) = @_;
		return $tx->res->body;
	});
}

method _build_params ($args) {
    my @args;
    for my $key (keys %$args) {
        $args->{$key} = defined $args->{$key} ? $args->{$key} : '';
        push @args,
            uc(uri_escape($key)) . '=' . uri_escape_utf8($args->{$key});
    }

    return (join '&', @args) || '';
}

1;
__END__