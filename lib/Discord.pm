package Discord;

use 5.010;
use Moo;
use LWP::UserAgent;
use MooX::Types::MooseLike::Base qw(InstanceOf);
use JSON::XS qw(decode_json encode_json);
use Data::Dumper;
our $VERSION = '0.001';

with 'Discord::Role::WebSocket';

has 'url' => (
    is      => 'ro',
    default => sub { 'https://discordapp.com/api' }
);

has 'ua' => (
    is      => 'ro',
    isa     => InstanceOf['LWP::UserAgent'],
    builder => '_build_ua'
);

has 'client_id'     => ( is => 'rw' );
has 'client_secret' => ( is => 'rw' );
has 'api_version'   => ( is => 'rw', default => sub { 6 } );
has 'encoding'      => ( is => 'rw', default => sub { 'json' } );
has 'shards'        => ( is => 'rw', default => sub { 0 } );
has 'bot'           => ( is => 'rw', default => sub { 0 } );
has 'token'         => ( is => 'rw' );
has 'gateway_url'   => ( is => 'rw' );
has 'header'        => ( is => 'rw' );
has 'base_name'     => ( is => 'rw' );

sub BUILD {
    my ($self, $args) = @_;
    # save the base name (package calling this library)
    # so we know where to fire off the event methods to
    my $caller = caller 1;
    $self->base_name($caller);

    # if client_id and client_secret are missing
    # then we must be a bot
    if (not $args->{client_id} and not $args->{client_secret}) {
        $self->bot(1);
    }

    # send the header with our authorization
    $self->set_header();

    # get the gateway url
    my $res = $self->request();
    if ($res and $res->{url}) {
        $self->gateway_url($res->{url});
        if ($res->{shards}) {
            $self->shards($res->{shards});
        }
    }
    else {
        die "Failed to retrieve gateway URL: $res->{message}\n";
    }
}

sub request {
    my ($self, $content) = @_;

    my $req = HTTP::Request->new(
        'GET',
        $self->api_url,
        $self->header,
    );

    my $res = decode_json($self->ua->request($req)->content);

    return $res;
}

sub api_url {
    my ($self) = @_;
    return ($self->bot) ?
        $self->url . '/gateway/bot' : '/gateway';
}

sub set_header {
    my ($self) = @_;
    my $h = HTTP::Headers->new;
    if ($self->bot and $self->token) {
        $h->header('Authorization' => 'Bot ' . $self->token);
    }
    
    $self->header($h);
    return $self;
}

sub connect {
    my ($self) = @_;
    # initialize the websocket
    $self->init_socket();
    return $self;
}

sub _build_ua {
    my $self = shift;

    my $lwp = LWP::UserAgent->new;
    $lwp->agent("p5-Discord/${VERSION}");
    return $lwp;
}

=head1 NAME

Discord - Discord API (WORK IN PROGRESS)

=head1 VERSION

Version 0.001

=cut

=head1 SYNOPSIS

  use 5.010;
  use Discord;
  
  my $discord = Discord->new(
      token => 'TOKEN_FOR_BOT',
  )->connect;
  
  sub discord_init {
      my ($self, $discobj, $res) = @_;
      say "Connected!";
  }

  sub discord_read {
      my ($self, $discobj, $message) = @_;
      say "Message -> $message";
  }

=cut

=head1 AUTHOR

Brad Haywood, C<< <brad at geeksware.com> >>

=head1 BUGS

There will be plenty.

=head1 ACKNOWLEDGEMENTS

- Me
- Coffee

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Brad Haywood.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Discord
