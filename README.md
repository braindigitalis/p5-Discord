# NAME

Discord - Discord API (WORK IN PROGRESS)

# VERSION

Version 0.001

# SYNOPSIS

```perl
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
    $self->discord->connect;
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
```

# AUTHOR

Brad Haywood, `<brad at geeksware.com>`

# BUGS

There will be plenty.

# ACKNOWLEDGEMENTS

- Lots of coffee
- Luna

# LICENSE AND COPYRIGHT

Copyright 2017 Brad Haywood.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

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

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 146:

    '=item' outside of any '=over'

- Around line 154:

    You forgot a '=back' before '=head1'
