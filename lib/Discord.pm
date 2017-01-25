package Discord;

use Mojo::UserAgent;
use MooX::Types::MooseLike::Base qw(InstanceOf);
use JSON::XS qw(decode_json encode_json);
use Discord::Loader;
use Discord::Common::Guild;

our $VERSION = '0.001';

with 'Discord::Client::WebSocket';
with 'Discord::Common::Helper';
with 'Discord::Common::REST';

has 'url' => (
    is      => 'ro',
    default => sub { 'https://discordapp.com/api' }
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
has 'guild'         => ( is => 'rw', default => sub { Discord::Common::Guild->new } );

func BUILD ($self, $args) {
    # save the base name (package calling this library)
    # so we know where to fire off the event methods to
    my $caller = caller 1;
    $self->base_name($caller);

    # load all the helper methods into the base class
    $self->load_helper($caller);

    # if client_id and client_secret are missing
    # then we must be a bot
    if (not $args->{client_id} and not $args->{client_secret}) {
        $self->bot(1);
    }

    #$ua->transactor->name('p5-Discord');
    #$ua->inactivity_timeout(110);
    #$ua->connect_timeout(10);

    $self->init_gateway();

}

method post_message ($url, $content) {
  $self->rest->post_req($url, $content);
}

method api_url {
    return ($self->bot) ?
        $self->url . '/gateway/bot' : '/gateway';
}

method connect ($base) {
    $self->base_name($base);
    # initialize the websocket
    $self->init_socket();
    return $self;
}

=head1 NAME

Discord - Discord API (WORK IN PROGRESS)

=head1 VERSION

Version 0.001

=cut

=head1 SYNOPSIS

  package DiscordBot;
  
  use Discord;
  use Discord::Loader; # imports signatures and Moo (optional)
  
  has 'discord' => (
      is      => 'ro',
      default => sub {
          Discord->new(
              token => 'MY_BOT_TOKEN'
          );
      }
  );
  
  # called when the constructor is run (new)
  func BUILD ($self) {
      # Pass the $self object to connect if you want to use $self
      # in return calls!
      $self->discord->connect($self);
  }
  
  method discord_ready ($disc, $msg) {
      say $disc->session->user->username
          . " is ready to rock 'n roll";
  }
  
  method discord_message ($disc, $message) {
      my ($channel, $guild) = (
          $message->channel,
          $message->channel->guild,
      );
      say "(" . $guild->name . ") <". $message->author->username
        . "/" . $channel->name . "> " . $message->content;

      if ($message->starts_with eq 'mojo,') {
          $channel->send_message("Hey there, " . $message->author->username . "!");
      }
  }
  
  method discord_guild_create ($disc, $guild) {
      say "=> Joined guild " . $guild->name;
      say "Members:";
      for my $member ($guild->members) {
          say "  - " . $member->username;
      }
      
      say "Channels:";
      for my $channel ($guild->channels) {
          say "  - " . $channel->name;
      }
  }
  
  DiscordBot->new;

=cut

=head1 AUTHOR

Brad Haywood, C<< <brad at geeksware.com> >>

=head1 BUGS

There will be plenty.

=head1 ACKNOWLEDGEMENTS

=item *

Lots of coffee

=item *

Luna

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
