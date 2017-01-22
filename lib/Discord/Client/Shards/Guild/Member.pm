package Discord::Client::Shards::Guild::Member;

use Discord::Loader;

#
#   'user' => {
#	   'username' => 'BaconBotDev',
#	   'id' => '145579551433424896',
#	   'discriminator' => '4478',
#	   'avatar' => 'f07338e22137a6e959b889379d8f3f1b'
#	},

has 'id'		=> ( is => 'rw' );
has 'roles'		=> ( is => 'rw', default => sub { [] } );
has 'username'	=> ( is => 'rw' );
has 'nick'		=> ( is => 'rw' );
has 'avatar' 	=> ( is => 'rw' );
has 'joined_at'	=> ( is => 'rw' );
has 'discriminator' => ( is => 'rw' );

1;
__END__