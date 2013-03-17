package MyObject;
use Mouse;
use Mouse::Util::TypeConstraints;

subtype 'MyObject::MultipleOfThree'
    => as 'Int'
    => where { $_ % 3 == 0 }
    => message {"This number ($_) is not divisible by three!"};

coerce 'MyObject::MultipleOfThree'
    => from 'Int'
    => via { $_ - $_ % 3}; # なにこの実装面白い

has number => (
    is => 'rw',
    # isa => 'Maybe[Int]',
    isa => 'MyObject::MultipleOfThree',
    coerce => 1,
);

has number_list => (
    is      => 'rw',
    isa     => 'ArrayRef[Int]',
);

has number_hash => (
    is      => 'rw',
    isa     => 'HashRef[Int]',
);

__PACKAGE__->meta->make_immutable;
no Mouse;

1;

#!/usr/bin/env perl
package main;
use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dump qw/dump/;
# use MyObject;

say dump my $object = MyObject->new;
# say $object->number(100);
say $object->number(8);
# say $object->number("hoge");

say dump $object->number_list([1, 2, 3, 4, 5]);
# say $object->number_list([qw(a b c)]);

say dump $object->number_hash({ a => 1, b => 2, c => 3, });
# say $object->number_hash({ a => "foo", b => "bar", });


