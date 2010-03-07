
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Test::Mock',
                       'DISTNAME' => 'Test-Mock',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Oliver Charles <oliver.g.charles@googlemail.com>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'A mock object testing framework in order to test behaviour and interactions between classes',
                       'EXE_FILES' => [],
                       'VERSION' => '0.02',
                       'PREREQ_PM' => {
                                        'MooseX::Types::Moose' => '0',
                                        'Test::Class::Most' => '0',
                                        'namespace::autoclean' => '0',
                                        'Data::Compare' => '0',
                                        'MooseX::Method::Signatures' => '0',
                                        'MooseX::Types::Structured' => '0',
                                        'List::MoreUtils' => '0',
                                        'Moose' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



