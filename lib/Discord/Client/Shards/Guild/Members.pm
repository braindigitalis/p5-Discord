package Discord::Client::Shards::Guild::Members;

use Discord::Loader;

has 'user_id'	=> ( is => 'rw' );
has 'status'	=> ( is => 'rw' );
has 'guild_id'	=> ( is => 'rw' );

1;
__END__