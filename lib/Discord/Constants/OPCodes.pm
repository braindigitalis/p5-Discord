package Discord::Constants::OPCodes;

# this package just allows us to use human readable names
# when referencing op codes
# eg: Discord::OPCodes::IDENTIFY instead of having remember it's '2'

use constant {
	DISPATCH		=> 0,
	HEARTBEAT 		=> 1,
	IDENTIFY 		=> 2,
    PRESENCE        => 3,
	RESUME			=> 6,
	RECONNECT 		=> 7,
	GUILD_REQUEST 	=> 8,
    INVALID_SESSION => 9,
	HELLO			=> 10,
	HEARTBEAT_ACK 	=> 11,
};

1;
__END__
