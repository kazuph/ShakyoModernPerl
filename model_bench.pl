#!/usr/bin/env perl
package ClassBless;
# 原始的なPerlの書き方
use strict;
use warnings;
use utf8;
use Data::Dump qw/dump/;
sub new {
    my $class = shift;
    my %args = @_;
    my $self = bless {
        rw1 => $args{rw1},
        rw2 => $args{rw2},
        rw3 => $args{rw3},
        rw4 => $args{rw4},
        rw5 => $args{rw5},
        rw6 => $args{rw6},
    }, $class;
    return $self;
}

package ClassCAF;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw/rw1 rw2 rw3 rw4 rw5 rw6/);

package ClassCAL;
use strict;
use warnings;
use Class::Accessor::Lite(
    # new => 1,
    ro => [qw(ro1 ro2 ro3 ro4 ro5 ro6)],
    rw => [qw(rw1 rw2 rw3 rw4 rw5 rw6)],
);
Class::Accessor::Lite->mk_new();

package ClassMoose;
use Moose;
has 'ro1' => ( is => 'ro', isa => 'Bool',      default => 1 );
has 'ro2' => ( is => 'ro', isa => 'Int',       default => 1 );
has 'ro3' => ( is => 'ro', isa => 'Str' ,      default => '1' );
has 'ro4' => ( is => 'ro', isa => 'ArrayRef' , default => sub { [] });
has 'ro5' => ( is => 'ro', isa => 'HashRef'  , default => sub { {} });
has 'ro6' => ( is => 'ro', isa => 'CodeRef'  , default => sub { sub {1} });
has 'rw1' => ( is => 'rw', isa => 'Bool',      default => 1 );
has 'rw2' => ( is => 'rw', isa => 'Int',       default => 1 );
has 'rw3' => ( is => 'rw', isa => 'Str' ,      default => '1' );
has 'rw4' => ( is => 'rw', isa => 'ArrayRef' , default => sub { [] });
has 'rw5' => ( is => 'rw', isa => 'HashRef'  , default => sub { {} });
has 'rw6' => ( is => 'rw', isa => 'CodeRef'  , default => sub { sub {1}  });
__PACKAGE__->meta->make_immutable;
no Moose;
1;

package ClassMouse;
use Mouse;
has 'ro1' => ( is => 'ro', isa => 'Bool',      default => 1 );
has 'ro2' => ( is => 'ro', isa => 'Int',       default => 1 );
has 'ro3' => ( is => 'ro', isa => 'Str' ,      default => '1' );
has 'ro4' => ( is => 'ro', isa => 'ArrayRef' , default => sub { [] });
has 'ro5' => ( is => 'ro', isa => 'HashRef'  , default => sub { {} });
has 'ro6' => ( is => 'ro', isa => 'CodeRef'  , default => sub { sub {1} });
has 'rw1' => ( is => 'rw', isa => 'Bool',      default => 1 );
has 'rw2' => ( is => 'rw', isa => 'Int',       default => 1 );
has 'rw3' => ( is => 'rw', isa => 'Str' ,      default => '1' );
has 'rw4' => ( is => 'rw', isa => 'ArrayRef' , default => sub { [] });
has 'rw5' => ( is => 'rw', isa => 'HashRef'  , default => sub { {} });
has 'rw6' => ( is => 'rw', isa => 'CodeRef'  , default => sub { sub {1}  });
__PACKAGE__->meta->make_immutable;
no Mouse;
1;

package ClassMoo;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
has 'ro1' => ( is => 'ro', isa => Bool,      default => 1 );
has 'ro2' => ( is => 'ro', isa => Int,       default => 1 );
has 'ro3' => ( is => 'ro', isa => Str ,      default => '1' );
has 'ro4' => ( is => 'ro', isa => ArrayRef , default => sub { [] });
has 'ro5' => ( is => 'ro', isa => HashRef  , default => sub { {} });
has 'ro6' => ( is => 'ro', isa => CodeRef  , default => sub { sub {1} });
has 'rw1' => ( is => 'rw', isa => Bool,      default => 1 );
has 'rw2' => ( is => 'rw', isa => Int,       default => 1 );
has 'rw3' => ( is => 'rw', isa => Str ,      default => '1' );
has 'rw4' => ( is => 'rw', isa => ArrayRef , default => sub { [] });
has 'rw5' => ( is => 'rw', isa => HashRef  , default => sub { {} });
has 'rw6' => ( is => 'rw', isa => CodeRef  , default => sub { sub {1}  });
__PACKAGE__->meta->make_immutable;
1;

package main;
use strict;
use warnings;
use Benchmark ':all';

my $bless = ClassBless->new;
my $caf = ClassCAF->new;
my $cal = ClassCAL->new;
my $moose = ClassMoose->new;
my $mouse = ClassMouse->new;
my $moo = ClassMoo->new;

no warnings 'void';
cmpthese(timethese(300000, {
   moose_ro => sub {
       $moose->ro1;
       $moose->ro2;
       $moose->ro3;
       $moose->ro4;
       $moose->ro5;
       $moose->ro6;
   },
   moose_rw => sub {
       $moose->rw1;
       $moose->rw2;
       $moose->rw3;
       $moose->rw4;
       $moose->rw5;
       $moose->rw6;
   },
   moose_direct => sub {
       $moose->{'rw1'};
       $moose->{'rw2'};
       $moose->{'rw3'};
       $moose->{'rw4'};
       $moose->{'rw5'};
       $moose->{'rw6'};
   },
   mouse_ro => sub {
       $mouse->ro1;
       $mouse->ro2;
       $mouse->ro3;
       $mouse->ro4;
       $mouse->ro5;
       $mouse->ro6;
   },
   mouse_rw => sub {
       $mouse->rw1;
       $mouse->rw2;
       $mouse->rw3;
       $mouse->rw4;
       $mouse->rw5;
       $mouse->rw6;
   },
   mouse_direct => sub {
       $mouse->{'rw1'};
       $mouse->{'rw2'};
       $mouse->{'rw3'};
       $mouse->{'rw4'};
       $mouse->{'rw5'};
       $mouse->{'rw6'};
   },
   moo_ro => sub {
       $moo->ro1;
       $moo->ro2;
       $moo->ro3;
       $moo->ro4;
       $moo->ro5;
       $moo->ro6;
   },
   moo_rw => sub {
       $moo->rw1;
       $moo->rw2;
       $moo->rw3;
       $moo->rw4;
       $moo->rw5;
       $moo->rw6;
   },
   moo_direct => sub {
       $moo->{'rw1'};
       $moo->{'rw2'};
       $moo->{'rw3'};
       $moo->{'rw4'};
       $moo->{'rw5'};
       $moo->{'rw6'};
   },
   caf_rw => sub {
       $caf->rw1;
       $caf->rw2;
       $caf->rw3;
       $caf->rw4;
       $caf->rw5;
       $caf->rw6;
   },
   caf_direct => sub {
       $caf->{'rw1'};
       $caf->{'rw2'};
       $caf->{'rw3'};
       $caf->{'rw4'};
       $caf->{'rw5'};
       $caf->{'rw6'};
   },
   cal_ro => sub {
       $cal->ro1;
       $cal->ro2;
       $cal->ro3;
       $cal->ro4;
       $cal->ro5;
       $cal->ro6;
   },
   cal_rw => sub {
       $cal->rw1;
       $cal->rw2;
       $cal->rw3;
       $cal->rw4;
       $cal->rw5;
       $cal->rw6;
   },
   cal_direct => sub {
       $cal->{'rw1'};
       $cal->{'rw2'};
       $cal->{'rw3'};
       $cal->{'rw4'};
       $cal->{'rw5'};
       $cal->{'rw6'};
   },
}));
