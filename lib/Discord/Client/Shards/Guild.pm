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

method members {
    if (wantarray) {
        return map { $self->member($_) } keys %{$self->_members};
    }
}

method add_members ($members) {
    for my $member (@$members) {
        $self->_members->{$member->{user}->{id}} = Discord::Client::Shards::Guild::Member->new(
            guild_id    => $self->guild_id,
            id          => $member->{user}->{id},
            roles       => $member->{roles},
            username    => $member->{user}->{username},
            nick        => $member->{nick},
            avatar      => $member->{user}->{avatar},
            joined_at   => $member->{joined_at},
            discriminator => $member->{user}->{discriminator},
        );
    }
}

method member ($member_id) {
    if (exists $self->_members->{$member_id}) {
        return $self->_members->{$member_id};
    }

    return;
}

method add_channels ($disc, $guild_id, $d) {
    my $channels = $d->{channels};
    for my $chan (@$channels) {
        $self->_channels->{$chan->{id}} = Discord::Client::Shards::Guild::Channel->new(
            guild_id => $guild_id,
            topic   => $chan->{topic},
            name    => $chan->{name},
            id      => $chan->{id},
            guild   => $self,
            disc    => $disc,
        );
    }
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
