package MyObject;
use Mouse;

has item => (
    is  => 'rw',
    isa => 'Comparable',
);

package Comparable;
use Mouse::Role;
requires 'compare';

package Base;
use Mouse;

package Object1;
use Mouse;
with 'Comparable';
sub compare {...};

package Object2;
use Mouse;
with 'Comparable';
sub compare {...};
