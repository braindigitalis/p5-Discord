package Discord::Common::REST;

use Discord::Loader as => 'Role';
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Headers;
use URI::Escape qw(uri_escape uri_escape_utf8 uri_unescape);
use Unicode::UTF8 qw(encode_utf8);
use JSON::XS qw(encode_json decode_json);

has 'ua' => ( is => 'rw', default => sub { LWP::UserAgent->new } );

method init_gateway {

    my $res = $self->get_req($self->api_url);
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

method get_req ($url, $content) {
    my $ua = $self->ua;
    if ($content) {
    	$url = "${url}?" . $self->_build_params($content);
    }

    my $req = HTTP::Request->new(GET => $url, $self->_headers);
    my $res = $self->ua->request($req);
    return decode_json($res->content);
}

method post_req ($url, $content) {
    $url = $self->url . $url;

    my $res = $self->ua->post($url, $self->_build_post_headers, Content => $content);
}

method _headers {
    my $h = HTTP::Headers->new(
        "Authorization" => "Bot " . $self->token,
        "User-Agent"    => 'p5-Discord',
    );

    return $h;
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

method _build_post_headers {
    return (
        "Authorization" => ($self->bot) ? "Bot " . $self->token : "Bearer " . $self->token,
        "User-Agent"    => "p5-Discord",
    );
}


1;
__END__