use strict;
use warnings;

use Test::More;
use Smolder::DB;
use Smolder::TestScript;
use Smolder::TestData qw(
  create_project
  delete_projects
  create_developer
  delete_developers
  create_preference
  delete_preferences
);

plan(tests => 7);

# 1
use_ok('Smolder::DB::Schema::Result::ProjectDeveloper');

END {
    delete_projects();
    delete_developers();
    delete_preferences();
}

# 2..6
# creation
my $proj_dev = Smolder::DB::rs('ProjectDeveloper')->create(
    {
        project    => create_project(),
        developer  => create_developer(),
        preference => create_preference(),
				added			 => DateTime->now(),
    }
);
isa_ok($proj_dev,             'Smolder::DB::Schema::Result::ProjectDeveloper');
isa_ok($proj_dev->added,      'DateTime');
isa_ok($proj_dev->project,    'Smolder::DB::Schema::Result::Project');
isa_ok($proj_dev->developer,  'Smolder::DB::Schema::Result::Developer');
isa_ok($proj_dev->preference, 'Smolder::DB::Schema::Result::Preference');

# 7
# delete
ok($proj_dev->delete);
