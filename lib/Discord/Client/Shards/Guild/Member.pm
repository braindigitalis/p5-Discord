package Discord::Client::Shards::Guild::Member;

use Discord::Loader;

has 'user_id'	=> ( is => 'rw' );
has 'status'	=> ( is => 'rw' );
has 'guild_id'	=> ( is => 'rw' );
has 'roles'		=> ( is => 'rw', default => sub { [] } );
has 'username'	=> ( is => 'rw' );
has 'nick'		=> ( is => 'rw' );
has 'avatar' 	=> ( is => 'rw' );
has 'joined_at'	=> ( is => 'rw' );
has 'id'		=> ( is => 'rw' );
has 'discriminator' => ( is => 'rw' );

1;
__END__