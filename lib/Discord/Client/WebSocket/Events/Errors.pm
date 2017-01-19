package Discord::Client::WebSocket::Events::Errors;

use Discord::Loader as => 'Role';

method handle_error ($code) {
    for ($code) {
        if($_ == Discord::Constants::OPCodes::INVALID_SESSION){
          return "Invalid Session";
        }
        elsif($_ == Discord::Constants::CloseCodes::UNKNOWN_ERROR){
          return "Unknown Error";
        }
        elsif($_ == Discord::Constants::CloseCodes::UNKNOWN_OPCODE){
          return "Invalid Gateway Opcode";
        }
        elsif($_ == Discord::Constants::CloseCodes::DECODE_ERROR){
          return "Invalid Payload";
        }
        elsif($_ == Discord::Constants::CloseCodes::NOT_AUTH){
          return "Not Authenticated";
        }
        elsif($_ == Discord::Constants::CloseCodes::AUTH_FAILED){
          return "Invalid Token";
        }
        elsif($_ == Discord::Constants::CloseCodes::ALREADY_AUTH){
          return "Already Authenticated";
        }
        elsif($_ == Discord::Constants::CloseCodes::INVALID_SEQ){
          return "Invalid sequence when resuming";
        }
        elsif($_ == Discord::Constants::CloseCodes::RATE_LIMITED){
          return "You are being rate limited";
        }
        elsif($_ == Discord::Constants::CloseCodes::SESSION_TIMEOUT){
          return "Session timed out";
        }
        elsif($_ == Discord::Constants::CloseCodes::INVALID_SHARD){
          return "Invalid Shard";
        }
        elsif($_ == Discord::Constants::CloseCodes::SHARDING_REQUIRED){
          return "Exceeded guild limit, sharding required";
        }
        else {
          return "Unknown Error"
        }
    }
}

1;
__END__
