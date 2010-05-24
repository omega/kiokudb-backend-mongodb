#!/usr/bin/perl
use Test::More;

BEGIN {
    plan skip_all => 'Please set KIOKU_MONGODB_HOST to a MONGODB_HOST' unless $ENV{KIOKU_MONGODB_HOST};
    plan 'no_plan';
}

use ok 'KiokuDB';
use ok 'KiokuDB::Backend::MongoDB::GIN';

use ok 'Search::GIN::Extract::Class';

use KiokuDB::Test;

my $port    = $ENV{KIOKU_MONGODB_PORT} || 27017;
my $db_name = $ENV{KIOKU_MONGODB_DB}   || "kioku-test-$$";
my $db_host = $ENV{KIOKU_MONGODB_HOST};



run_all_fixtures(
    KiokuDB->new(
        backend => KiokuDB::Backend::MongoDB::GIN->new(
            extract => Search::GIN::Extract::Class->new,
            root_only => 0,
            database_name => $db_name,
            database_host => $db_host,
            database_port => $port,
            collection_name => 'gintest',
            
        ),
    )
);

