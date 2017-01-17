use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Discord',
    AUTHOR           => q{Brad Haywood <brad@geeksware.com>},
    VERSION_FROM     => 'lib/Discord.pm',
    ABSTRACT_FROM    => 'lib/Discord.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'MooX::Types::MooseLike::Base' => 0,
        'JSON::XS' => 0,
        'Moo' => 0,
        'Mojo::UserAgent' => 0,
        'Mojo::IOLoop' => 0,
        'Compress:Zlib' => 0,
        'Method::Signatures::Simple' => 0,
        'Import::Into' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Discord-*' },
);
