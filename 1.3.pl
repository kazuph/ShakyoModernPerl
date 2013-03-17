#!/usr/bin/env perl
package EchoServer;
use Moose;

has 'address' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
);

has 'port' => (
    is => 'rw',
    isa => 'Int',
    required => 1,
    default => 8080,
);

has 'server_socket' => (
    is      => 'rw',
    isa     => 'IO::Socket',
    lazy_build => 1,
    # lazy => 1,
    # builder => 'build_server_socket',
);

sub _build_server_socket {
    my $self = shift;
    IO::Socket::INET->new(
        Listen => 5,
        LocalAddr => $self->address,
        LocalPort => $self->port,
        Proto => 'tcp',
    );
}

__PACKAGE__->meta->make_immutable;
no Moose;

use IO::Socket::INET;

sub BUILD {
    my $self = shift;
    $self->bind;
    return $self;
}

sub bind {
    my $self = shift;
    my $socket = IO::Socket::INET->new(
        Listen => 5,
        LocalAddr => $self->address,
        LocalPort => $self->port,
        Proto => 'tcp',
    );

    if (!$socket) {
        die "ソケットを作成できませんでした:$@";
    }

    $self->server_socket( $socket );
}

sub run {
    my $self = shift;

    my $socket = $self->server_socket;
    while (my $client = $socket->accept) {
        $self->process_request($client);
    }
}

sub process_request {
    my ($self, $client) = @_;

    while (!$client->eof) {
        my $req = $self->read_request($client);
        $self->write_response($client, $req);
    }
}

# Echo サーバーなので1行だけ読む
sub read_request {
    my ($self, $client) = @_;
    my $line = <$client>;
    return $line;
}

# Echo サーバーなので1行だけ読む
sub write_response {
    my ($self, $client, $request) = @_;
    print $client $request;
}
1;

package TimestampedEchoServer;
use Moose;

extends 'EchoServer';
# sub write_response {
#     my ($self, $client, $request) = @_;
#     print $client scalar(localtime), " ";
#     $self->SUPER::write_response($client, $request);
# }

# before 'write_response' => sub {
#     my ($self, $client, $request) = @_;
#     print $client scalar(localtime), " ";
# };

# override 'write_response' => sub {
#     my ($self, $client, $request) = @_;
#     print $client scalar(localtime), " ";
#     super();
# };

around 'write_response' => sub {
    my ($next, $self, $client, $request) = @_;
    $request = join(' ', scalar localtime, $request);
    $next->($self, $client, $request);
};

package main;
use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dump qw/dump/;

# my $s = EchoServer->new(
#     address => '127.0.0.1',
#     port => '9999',
# );
my $s = TimestampedEchoServer->new(
    address => '127.0.0.1',
    port => '9999',
);
# $s->bind;
$s->run;
