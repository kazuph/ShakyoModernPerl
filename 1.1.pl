#!/usr/bin/env perl
package MyObject;
# 原始的なPerlの書き方
use strict;
use warnings;
use utf8;
use Data::Dump qw/dump/;
sub new {
    my $class = shift;
    my %args = @_;
    my $self = bless {
        aaa => $args{aaa},
        bbb => $args{bbb},
        ccc => $args{ccc},
    }, $class;
    return $self;
}

package MyObjCAF;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw(aaa bbb ccc));

package MyObjCAL;
use strict;
use warnings;
use Class::Accessor::Lite(
    new => 1,
    rw => [qw(aaa bbb ccc)],
);

package MyObjMoose;
use Moose;
has 'aaa' => (is => 'rw');
has 'bbb' => (is => 'rw');
has 'ccc' => (is => 'rw');

__PACKAGE__->meta->make_immutable;

no Moose;

1;

package main;
use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dump qw/dump/;

# Hogeという名前空間にあるリファレンスを定義する
my %h = (a => 1);
my $r = \%h;
bless $r, 'Hoge';
say dump $r;

# 上で定義したクラスを呼ぶ
say '#bless';
my $obj = MyObject->new(aaa => 'hoge', bbb => 'fuga', ccc => 'piyo');
say dump $obj;

# C::A::F なnewをする
say '#C::A::F';
$obj = MyObjCAF->new({aaa => 'hoge', bbb => 'fuga', ccc => 'piyo'});
say dump $obj;
$obj->aaa(123);
say $obj->aaa;

# C::A::L なnewをする
say '#C::A::L';
$obj = MyObjCAL->new({aaa => 'hoge', bbb => 'fuga', ccc => 'piyo'});
say dump $obj;
$obj->aaa(123);
say $obj->aaa;

# Mooseなnewをする
say '#Moose';
$obj = MyObjMoose->new({aaa => 'hoge', bbb => 'fuga', ccc => 'piyo'});
say dump $obj;
$obj->aaa(123);
say $obj->aaa;
