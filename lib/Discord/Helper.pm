package Discord::Helper;

use Import::Into ();
use Method::Signatures::Simple
		method_keyword   => 'method',
		function_keyword => 'func';

sub import {
	my $caller = caller;
	Method::Signatures::Simple->import::into($caller);
}

1;
__END__