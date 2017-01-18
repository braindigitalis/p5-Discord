package Discord::Common::Throttler;

use Discord::Loader;

has 'frequency' => ( is => 'rw' );
has 'limit'		=> ( is => 'rw' );

sub apply_to {
	my ($self, $func) = @_;
	my $throttle = sub {
		warn "Throttling $func";
	};

	throttle: {
		no strict 'refs';
		no warnings 'redefine';

		my $orig = \&{$func};

		*{"${func}"} = sub {
			warn $throttle;
            $throttle->(@_);
            $orig->(@_);
        };
	}
}

1;
__END__