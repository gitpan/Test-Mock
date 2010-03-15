package Test::Mock::Types;
our $VERSION = '0.06';
# ABSTRACT: Types used by Test::Mock
use MooseX::Types -declare => [qw( Expectation Invocation )];

class_type Expectation, { class => 'Test::Mock::Expectation' };
class_type Invocation, { class => 'Test::Mock::Invocation' };

1;

__END__
=pod

=head1 NAME

Test::Mock::Types - Types used by Test::Mock

=head1 VERSION

version 0.06

=head1 AUTHOR

  Oliver Charles <oliver.g.charles@googlemail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

