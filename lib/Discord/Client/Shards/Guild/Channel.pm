package Discord::Client::Shards::Guild::Channel;

use Discord::Loader;

has 'topic'	=> ( is => 'rw' );
has 'name'	=> ( is => 'rw' );
has 'id'	=> ( is => 'rw' );
has 'guild_id' => ( is => 'rw' );
has 'guild'	=> ( is => 'rw' );
1;
__END__