package Discord::Client::Shards::Guild::Channel;

use Discord::Loader;

has 'topic'	=> ( is => 'rw' );
has 'name'	=> ( is => 'rw' );
has 'id'	=> ( is => 'rw' );

1;
__END__