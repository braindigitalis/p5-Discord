package Discord::Loader;

use 5.010;
use Import::Into ();
use Method::Signatures::Simple
		method_keyword   => 'method',
		function_keyword => 'func';

sub import {
	my ($class, %opts) = @_;
	my $caller = caller;
    feature->import(':5.10');
	if (exists $opts{as}) {
		if ($opts{as} eq 'Role') {
			 __PACKAGE__->_load_framework ($caller, "Moo::Role");
		}
	}
	else {
		__PACKAGE__->_load_framework ($caller, "Moo");
	}
	
	Method::Signatures::Simple->import::into($caller);
}

sub _load_framework {
    my ($self, $target, $module) = @_;
    (my $file = $module) =~ s|::|/|g;
    require "$file.pm";
    
    loadit: {
        local $@;
        eval qq{
            package $target;
            $module->import();
        };
    }
    
    return 1;
}

1;
__END__
