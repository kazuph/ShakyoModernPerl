package Comparable;
use Mouse::Role;
requires 'compare';

package Integer;
use Mouse;
with 'Comparable';

sub compare { $_[0] <=> $_[1] };

package String;
use Mouse;
with 'Comparable';

sub compare { $_[0] cmp $_[1] };
