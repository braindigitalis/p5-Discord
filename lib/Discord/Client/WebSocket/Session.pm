package Discord::Client::WebSocket::Session;

use 5.010;
use Discord::Loader;
use Discord::Client::WebSocket::Session::User;

has 'user' => ( is => 'ro', default => sub { Discord::Client::WebSocket::Session::User->new } );

1;
__END__
