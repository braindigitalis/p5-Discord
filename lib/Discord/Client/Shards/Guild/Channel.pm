package Discord::Client::Shards::Guild::Channel;

use Discord::Loader;
use Discord::Constants::Endpoints;
use Unicode::UTF8;

with 'Discord::Common::REST';

has 'topic'	=> ( is => 'rw' );
has 'name'	=> ( is => 'rw' );
has 'id'	=> ( is => 'rw' );
has 'guild_id' => ( is => 'rw' );
has 'guild'	=> ( is => 'rw' );
has 'disc'	=> ( is => 'rw' );

method send_message ($message) {
	$self->disc->post_req(
		Discord::Constants::Endpoints::CHANNEL_MESSAGES($self->id),
		[
			content => Unicode::UTF8::encode_utf8($message),
		]
	);
}

1;
__END__