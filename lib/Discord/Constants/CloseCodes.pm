package Discord::Constants::CloseCodes;

# This package renames the gateway close event codes to human readable names
# EG: Discord::Constants::CloseCodes::UNKNOWN_ERROR would be 4000
# These follow the description specified in the API documentation,
# although to keep things short, 'authentication' is renamed 'auth'

use constant {
  UNKNOWN_ERROR => 4000,
  UNKNOWN_OPCODE => 4001,
  DECODE_ERROR => 4002,
  NOT_AUTH => 4003,
  AUTH_FAILED => 4004,
  ALREADY_AUTH => 4005,
  INVALID_SEQ => 4007,
  RATE_LIMITED => 4008,
  SESSION_TIMEOUT => 4009,
  INVALID_SHARD => 4010,
  SHARDING_REQUIRED => 4011,
};

1;
__END__
