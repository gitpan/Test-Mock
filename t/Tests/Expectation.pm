package Tests::Expectation;
our $VERSION = '0.05';
use strict;
use warnings;
use base 'Test::Class';
use Test::Class::Most;

use Test::Mock::Expectation;

{
    package Receiver;
our $VERSION = '0.05';
    use Moose;
}

sub chained : Test(2)
{
    my $expectation = Test::Mock::Expectation->new(
        receiver => Receiver->new,
        method   => 'blah',
    );

    $expectation->parameters(['over', 9000])->return('waffles');

    is_deeply($expectation->parameters, [ 'over', 9000 ]);
    is($expectation->return, 'waffles');
}

1;
