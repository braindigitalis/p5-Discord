package Discord::Client::WebSocket::Session;

use Discord::Loader;
use Discord::Constants::OPCodes;
use Discord::Client::WebSocket::Session::User;

has 'user' => ( is => 'ro', default => sub { Discord::Client::WebSocket::Session::User->new } );
has 'disc' => ( is => 'rw' );

method update_status ($status) {
    $self->disc->_send({
        op => Discord::Constants::OPCodes::PRESENCE,
        d  => {
            idle_since => undef,
            game => { name => $status }
        },
    });
}

1;
__END__
