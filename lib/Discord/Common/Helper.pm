package Discord::Common::Helper;

use Discord::Loader as => 'Role';

# just some stuff to make the bot developers lives easier

# grabs the first word of a string and returns it
func import_starts_with ($class, $str) {
    my ($first) = split / /, $str;
    return $first;
}

# converts a string to array
func import_to_array ($class, $str) {
    return split / /, $str;
}

method load_helper ($base) {
    {
        no strict 'refs';
        for my $m (keys %{"Discord::Common::Helper::"}) {
            if ($m =~ /^import_/) {
                $m =~ s/import_//g;
                *{"${base}::${m}"} = *{"Discord::Common::Helper::import_${m}"};
            }
        }
    }
}

1;
__END__
