package Discord::Client::WebSocket::Events::Errors;

use Discord::Loader as => 'Role';

method handle_error ($code) {
    if(Discord::Constants::OPCodes::INVALID_SESSION){
      return "Invalid Session";
    }
    elsif(Discord::Constants::CloseCodes::UNKNOWN_ERROR){
      return "Unknown Error";
    }
    elsif(Discord::Constants::CloseCodes::UNKNOWN_OPCODE){
      return "Invalid Gateway Opcode";
    }
    elsif(Discord::Constants::CloseCodes::DECODE_ERROR){
      return "Invalid Payload";
    }
    elsif(Discord::Constants::CloseCodes::NOT_AUTH){
      return "Not Authenticated";
    }
    elsif(Discord::Constants::CloseCodes::AUTH_FAILED){
      return "Invalid Token";
    }
    elsif(Discord::Constants::CloseCodes::ALREADY_AUTH){
      return "Already Authenticated";
    }
    elsif(Discord::Constants::CloseCodes::INVALID_SEQ){
      return "Invalid sequence when resuming";
    }
    elsif(Discord::Constants::CloseCodes::RATE_LIMITED){
      return "You are being rate limited";
    }
    elsif(Discord::Constants::CloseCodes::SESSION_TIMEOUT){
      return "Session timed out";
    }
    elsif(Discord::Constants::CloseCodes::INVALID_SHARD){
      return "Invalid Shard";
    }
    elsif(Discord::Constants::CloseCodes::SHARDING_REQUIRED){
      return "Exceeded guild limit, sharding required";
    }
    else {
      return "Unknown Error"
    }
}

1;
__END__
