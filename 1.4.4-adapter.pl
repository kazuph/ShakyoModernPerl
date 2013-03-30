package MyApp::Role::Cache {
    use Mouse::Role;

    # Roleなのにデータを持っていいの？
    has cache => (
        is       => 'rw',
        required => 1,
    );

    requires qw/get set delete clear/;

};

package MyApp::Cache::Memcached {
    use Data::Dump qw(dump);
    use feature 'say';
    use Mouse;

    with 'MyApp::Role::Cache';
    has '+cache' => ( isa => 'Cache::Memcached', );

    __PACKAGE__->meta->make_immutable;
    no Mouse;

    sub get    { say dump @_; shift->cache->get(@_); }
    sub set    { say dump @_; shift->cache->set(@_); }
    sub delete { say dump @_; shift->cache->delete(@_); }
    sub clear  { say dump @_; shift->cache->flush_all(@_); }
};

package MyApp::Cache::Cache {
    use Mouse;
    use Data::Dump qw(dump);
    use feature 'say';

    with 'MyApp::Role::Cache';

    has '+cache' => ( isa => 'Cache::Memcached', );

    __PACKAGE__->meta->make_immutable;
    no Mouse;

    sub get    { say dump @_; shift->cache->get(@_); }
    sub set    { say dump @_; shift->cache->set(@_); }
    sub delete { say dump @_; shift->cache->delete(@_); }
    sub clear  { say dump @_; shift->cache->Clear(@_); }

};

package MyApp;
use Mouse;

has 'cache' => (
    is   => 'rw',
    dose => 'MyApp::Role::Cache',
    handles => {
        cache_get => 'get',
        cache_set => 'set',
        cache_delete => 'delte',
        cache_clear => 'clear',
    }
);

__PACKAGE__->meta->make_immutable;
no Mouse;

1;

package main;
use strict;
use warnings;
use 5.010000;
use autodie;
use Data::Dump qw(dump);
use feature 'say';
use Cache::Memcached;
my $obj =
  MyApp::Cache::Memcached->new(
    cache => Cache::Memcached->new( { servers => '127.0.0.1' } ) );

say dump $obj->set( "my_key", "Some value" );
say dump $obj->get("my_key");
say dump $obj->delete("my_key");
say dump $obj->clear();
