package Discord::Client::Shards::Guild::Member;

use Discord::Loader;

has 'id'		=> ( is => 'rw' );
has 'roles'		=> ( is => 'rw', default => sub { [] } );
has 'username'	=> ( is => 'rw' );
has 'nick'		=> ( is => 'rw' );
has 'avatar' 	=> ( is => 'rw' );
has 'joined_at'	=> ( is => 'rw' );
has 'discriminator' => ( is => 'rw' );

1;
__END__