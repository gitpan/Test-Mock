#!/usr/bin/env perl -T

use lib 't';
use Tests::Mock;
use Tests::Expectation;
use Tests::EG::PublisherSubscriber;

Test::Class->runtests;
