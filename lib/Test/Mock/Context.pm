package Test::Mock::Context;
BEGIN {
  $Test::Mock::Context::VERSION = '0.07';
}
# ABSTRACT: The mocking context which oversees the mocking process
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( ArrayRef Object Str );
use MooseX::Types::Structured qw( Map Tuple );
use Test::Mock::Types qw( Expectation Invocation );
use namespace::autoclean;

use Carp qw( confess );
use List::MoreUtils qw( zip );
use Moose::Meta::Class;
use Class::MOP;
use Class::MOP::Method;
use Test::Mock::Expectation;
use Test::Mock::Invocation;

has 'expectations' => (
    is      => 'ro',
    isa     => Map[Object, ArrayRef[Expectation]],
    default => sub { {} },
);

has 'run_log' => (
    is      => 'ro',
    isa     => ArrayRef[Invocation],
    traits  => [ 'Array' ],
    default => sub { [] },
    handles => {
        _add_invocation => 'push'
    }
);

has 'sat' => (
    isa     => 'Bool',
    is      => 'rw',
    default => 1,
);

method mock (Str $class)
{
    Class::MOP::load_class($class);
    my $package = $class . '::Mock';

    my (@superclasses, @roles, @methods);
    if (my $meta = Class::MOP::Class->initialize($class)) {
        if ($meta->isa('Moose::Meta::Role')) {
            @methods = $class->meta->get_method_list;
            @roles = $class;
        }
        else {
            @superclasses = ($class);
            @methods = $class->meta->get_all_method_names;
        }
    }

    my $mock = Moose::Meta::Class->create(
        $package => (
            superclasses => [ @superclasses ],
            methods      => {
                map {
                    my $method = $_;
                    $method => sub {
                        my $mock = shift;
                        $self->invoke($mock, $method, @_);
                    }
                } grep { $self->should_mock($_) } @methods
            },
            @roles ? (roles => [ @roles ]) : ()
        ));

    # Make all attributes not-required, and remove delegation (we've already stubbed the methods)
    for my $attribute ($mock->get_all_attributes) {
        $mock->add_attribute($attribute->clone(required => 0, handles => {}))
    }

    return $mock->new_object;
}

method invoke (Object $receiver, Str $method, @parameters)
{
    my @expectations = @{ $self->expectations->{$receiver} || [] };

    my $invocation = Test::Mock::Invocation->new(
        receiver   => $receiver,
        method     => $method,
        parameters => \@parameters
    );

    $self->_add_invocation($invocation);

    my $expectation = shift @{ $self->expectations->{$receiver} };
    if (!defined $expectation || !$expectation->is_satisfied_by($invocation)) {
        $self->sat(0);
        confess"$method was invoked but not expected";
    }

    return $expectation->return;
}

method should_mock (Str $method_name)
{
    return !($method_name =~ /can|DEMOLISHALL|DESTROY|DOES|does|meta|isa|VERSION/);
}

method expect (Object $mock, Str $method_name)
{
    my $expectation = Test::Mock::Expectation->new(
        receiver => $mock,
        method   => $method_name
    );
    $self->expectations->{$mock} ||= [];
    push @{ $self->expectations->{$mock} }, $expectation;

    return $expectation;
}

method satisfied
{
    my @remaining_expectations = map { @{$_} } values %{ $self->expectations };
    return $self->sat && @remaining_expectations == 0;
}

__PACKAGE__->meta->make_immutable;


__END__
=pod

=head1 NAME

Test::Mock::Context - The mocking context which oversees the mocking process

=head1 VERSION

version 0.07

=head1 METHODS

=head2 mock(Str $class) : Object

Mock the class named C<$class>. The mock object will be C<ISA $class>,
and will have all the methods that C<$class> does (but obviously
invoking them doesn't run them).

=head2 expect(Object $receiver, Str $method_name) : Test::Mock::Expectation

Register an expected method call of C<$method_name> on
C<$receiver>. This will return a C<Test::Mock::Expectation>, which you
can specialize further with chaining if you need to specify further
constraints.

=head2 satisfied : Bool

Check through the list of expectations and invocations, and make sure
that they are consistent. That is, every invocation satisfies some
sort of expectation in the correct order.

=head1 AUTHOR

  Oliver Charles <oliver.g.charles@googlemail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

