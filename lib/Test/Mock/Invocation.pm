package Test::Mock::Invocation;
our $VERSION = '0.03';
# ABSTRACT: Represents an actual invocation of a method
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( ArrayRef Object Str );
use namespace::autoclean;

has 'receiver' => (
    is       => 'ro',
    isa      => Object,
    required => 1
);

has 'method' => (
    is       => 'ro',
    isa      => Str,
    required => 1
);

has 'parameters' => (
    is        => 'ro',
    isa       => ArrayRef,
    predicate => 'has_parameters'
);

__PACKAGE__->meta->make_immutable;


__END__
=pod

=head1 NAME

Test::Mock::Invocation - Represents an actual invocation of a method

=head1 VERSION

version 0.03

=head1 ATTRIBUTES

=head2 receiver

B<Required>. The object that the method was invoked on.

=head2 method

B<Required>. The name of the method invoked.

=head2 parameters

All the parameters passed to the method (except $self).

=head1 AUTHOR

  Oliver Charles <oliver.g.charles@googlemail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

