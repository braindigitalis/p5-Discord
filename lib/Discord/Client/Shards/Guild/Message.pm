package Discord::Client::Shards::Guild::Message;

use Discord::Loader;

has 'content' 			=> ( is => 'rw' );
has 'type'				=> ( is => 'rw' );
has 'edited_timestamp' 	=> ( is => 'rw' );
has 'tts'				=> ( is => 'rw', default => sub { 0 } );
has 'author'			=> ( is => 'rw' ); # Guild::Message::User
has 'id'				=> ( is => 'rw' );
has 'nonce'				=> ( is => 'rw' );
has 'timestamp' 		=> ( is => 'rw' );
has 'mention_roles' 	=> ( is => 'rw', default => sub { [] } );
has '_mentions'  		=> ( is => 'rw', default => sub { {} } );
has 'channel_id' 		=> ( is => 'rw' );
has 'channel'           => ( is => 'rw' );
has 'disc'              => ( is => 'rw' );

method mentions {
    if (wantarray) {
        return map { $self->mention($_) } keys %{$self->_mentions};
    }
}

method mention ($user_id) {
    if (exists $self->_mentions->{$user_id}) {
        return $self->_mentions->{$user_id};
    }

    return;
}

method add_mentions ($mentions) {
    for my $mention (@$mentions) {
        $self->_mentions->{$mention->{id}} = Discord::Client::Shards::Guild::Message::User->new(
            username    	=> $mention->{user}->{username},
            avatar      	=> $mention->{user}->{avatar},
            discriminator 	=> $mention->{user}->{discriminator},
            id 				=> $mention->{id},
        );
    }
}

# Helper methods
method starts_with {
    my ($first) = split / /, $self->content;
    return $first;
}

method mentioned {
    my $first = $self->starts_with;
    if ($first eq '<@' . $self->disc->session->user->id . '>') { return 1; }
    return 0;
}

method string {
    my $line = $self->content;
    $line =~ s/^\S+\s*//;
    return $line;
}

1;
__END__
