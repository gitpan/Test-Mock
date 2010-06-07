
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'A mock object testing framework in order to test behaviour and interactions between classes',
  'AUTHOR' => 'Oliver Charles <oliver.g.charles@googlemail.com>',
  'BUILD_REQUIRES' => {},
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Test-Mock',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Test::Mock',
  'PREREQ_PM' => {
    'Data::Compare' => '0',
    'List::MoreUtils' => '0',
    'Moose' => '0',
    'MooseX::ChainedAccessors::Accessor' => '0',
    'MooseX::Method::Signatures' => '0',
    'MooseX::Types::Moose' => '0',
    'MooseX::Types::Structured' => '0',
    'Test::Class::Most' => '0',
    'namespace::autoclean' => '0'
  },
  'VERSION' => '0.07',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



