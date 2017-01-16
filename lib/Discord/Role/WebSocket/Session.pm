package Discord::Role::WebSocket::Session;

use 5.010;
use Moo;
use Discord::Role::WebSocket::Session::User;

has 'user' => ( is => 'ro', default => sub { Discord::Role::WebSocket::Session::User->new } );

1;
__END__
