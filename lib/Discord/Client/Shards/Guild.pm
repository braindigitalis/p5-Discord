package Discord::Client::Shards::Guild;

use Discord::Loader;
use Discord::Client::Shards::Guild::Members;

# guild properties
has 'owner_id'      => ( is => 'rw' );
has 'guild_id'      => ( is => 'rw', required => 1 );
has 'name'          => ( is => 'rw', required => 1 );
has 'roles'         => ( is => 'rw', default => sub { [] } );
has 'members'       => ( is => 'rw', default => sub { Discord::Client::Shards::Guild::Members->new });

1;
__END__
