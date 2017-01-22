package Discord::Client::Shards::Guild;

use Discord::Loader;
use Discord::Client::Shards::Guild::Member;
use Discord::Client::Shards::Guild::Channel;

# guild properties
has 'owner_id'      => ( is => 'rw' );
has 'guild_id'      => ( is => 'rw', required => 1 );
has 'name'          => ( is => 'rw', required => 1 );
has 'roles'         => ( is => 'rw', default => sub { [] } );

# underscored properties because we don't want these to be global!
has '_channels'      => ( is => 'rw', default => sub { {} } );
has '_members'       => ( is => 'rw', default => sub { {} } );

method add_channels ($channels) {
    for my $chan (@$channels) {
        $self->_channels->{$chan->{id}} = Discord::Client::Shards::Guild::Channel->new(
            topic   => $chan->{topic},
            name    => $chan->{name},
            id      => $chan->{id},
        );
    }
}

method add_members ($members) {
}

method channels {
    if (wantarray) {
        return map { $self->channel($_) } keys %{$self->_channels};
    }
}

method channel ($channel_id) {
    if (exists $self->_channels->{$channel_id}) {
        return $self->_channels->{$channel_id};
    }

    return;
}

1;
__END__
