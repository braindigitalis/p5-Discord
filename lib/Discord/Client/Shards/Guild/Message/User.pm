package Discord::Client::Shards::Guild::Message::User;

use Discord::Loader;

has 'id'		=> ( is => 'rw' );
has 'username'	=> ( is => 'rw' );
has 'avatar'	=> ( is => 'rw' );
has 'discriminator' => ( is => 'rw' );

1;
__END__