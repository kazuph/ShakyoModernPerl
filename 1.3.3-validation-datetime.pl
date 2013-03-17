package MyObject;
use Mouse;
use Mouse::Util::TypeConstraints;
use DateTime;
use DateTime::Format::Strptime;

my $parser = DateTime::Format::Strptime->new(
    pattern => '%Y-%m-%d %H:%M:%S',
    time_zone => 'local',
);

class_type 'DateTime';

coerce 'DateTime'
    => from 'Str',
    => via {$parser->parse_datetime($_)}
;

coerce 'DateTime'
    => from 'HashRef',
    => via {DateTime->new(%$_)}
;

has datetime => (
    is     => 'rw',
    isa    => 'DateTime',
    coerce => 1
);

__PACKAGE__->meta->make_immutable;
no Mouse;
no Mouse::Util::TypeConstraints;

1;

#!/usr/bin/env perl
package main;
use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dump qw/dump/;

my $object = MyObject->new();

say dump $object->datetime('2013-03-20 21:55:02');
say dump $object->datetime({
    year   => 2013,
    month  => 3,
    day    => 20,
    hour   => 21,
    minute => 55,
    second => 2,
});
