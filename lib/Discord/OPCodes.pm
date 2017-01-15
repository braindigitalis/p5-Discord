package Discord::OPCodes;

use constant {
	DISPATCH		=> 0,
	HEARTBEAT 		=> 1,
	IDENTIFY 		=> 2,
	RESUME			=> 6,
	RECONNECT 		=> 7,
	GUILD_REQUEST 	=> 8,
	HELLO			=> 10,
	HEARTBEAT_ACK 	=> 11,
};

1;
__END__