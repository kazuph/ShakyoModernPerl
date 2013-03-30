package Animal;
use Mouse;

package Mammal;
use Mouse;
extends 'Animal';

package Bird;
use Mouse;
extends 'Animal';

package Winged;
use Mouse::Role;
requires 'fly';

package Bat;
use Mouse;
extends 'Mammal';
with 'Winged';

sub fly {
    print "Bats fly in the night.\n";
}

package Pigeon;
use Mouse;
extends 'Bird';
with 'Winged';

sub fly {
    print "Pigeons fly in the day.\n";
}

package main;
my $b = Bat->new();
$b->fly;
my $p = Pigeon->new();
$p->fly;

