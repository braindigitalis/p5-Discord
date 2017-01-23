package Discord::Common::Guild;

use Discord::Loader;
use Discord::Client::Shards::Guild;

# a hashref to hold the guild objects
has 'guilds'        => ( is => 'rw', default => sub { {} } );

method add ($args) {
	# create and return the new Guild object
	my $guild_obj = Discord::Client::Shards::Guild->new(
		owner_id => $args->{owner_id},
		guild_id => $args->{guild_id},
		name     => $args->{name},
		roles    => $args->{roles} // [],
	);

	$self->guilds->{$args->{guild_id}} = $guild_obj;
	return $guild_obj;
}

method get ($guild_id) {
	# try to find the guild based on the id
	# otherwise return nothing
	if (exists $self->guilds->{$guild_id}) { return $self->guilds->{$guild_id}; }
    return;
}

method count {
	return keys %{$self->guilds};
}

method find ($args) {
	foreach my $key (keys %$args) {
		# search based on channel_id
		if ($key eq 'channel') {
			foreach my $gid (keys %{$self->guilds}) {
				if ($self->guilds->{$gid}->_channels->{$args->{$key}}) {
					return $self->guilds->{$gid}->_channels->{$args->{$key}};
				}
			}

			# we found nada
			return;
		}
	}
}

1;
__END__
