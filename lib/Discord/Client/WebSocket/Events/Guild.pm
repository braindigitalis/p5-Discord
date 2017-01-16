package Discord::Client::WebSocket::Events::Guild;

use 5.010;
use Moo::Role;

sub on_message_create {
    my ($self, $d) = @_;
    my $base = $self->base_name;
    if ($base->can('discord_message')) {
        $base->discord_message($self, $d);
    }
}

sub handle_guild_events {
    my ($self, $type, $d) = @_;
    # lowercase the event name, and append on_
    my $method = lc "on_$type";
    
    # finally check to see if we have a call for it
    # and then pass the data object to it
    if ($self->can($method)) {
        $self->$method($d);
    }
}

1;
__END__
