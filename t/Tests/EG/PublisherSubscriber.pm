package Tests::EG::PublisherSubscriber;
our $VERSION = '0.04';
use strict;
use warnings;
use base 'Test::Class';
use Test::Class::Most;

{
    package Subscriber;
our $VERSION = '0.04';
    use Moose;
    sub receive { }
}

{
    package Publisher;
our $VERSION = '0.04';
    use Moose;

    has 'subscribers' => (
        is      => 'ro',
        isa     => 'ArrayRef',
        traits  => [ 'Array' ],
        default => sub { [] },
        handles => {
            add_subscriber => 'push'
        }
    );

    sub publish
    {
        my ($self, $message) = @_;
        for my $sub (@{ $self->subscribers }) {
            $sub->receive($message);
        }
    }
}

sub oneSubscriberReceivesMessage : Test
{
    my $context = Test::Mock::Context->new;
    my $subscriber = $context->mock('Subscriber');
    my $publisher = Publisher->new();
    $publisher->add_subscriber($subscriber);

    my $message = 'message';

    $context->expect($subscriber, 'receive')->parameters([ $message ]);

    $publisher->publish($message);

    ok $context->satisfied;
}

1;
