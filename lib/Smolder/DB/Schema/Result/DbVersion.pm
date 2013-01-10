use utf8;
package Smolder::DB::Schema::Result::DbVersion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::DbVersion

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<db_version>

=cut

__PACKAGE__->table("db_version");

=head1 ACCESSORS

=head2 db_version

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("db_version", { data_type => "text", is_nullable => 0 });


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 09:16:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F73j7R19J2FD69zL1QSsXA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
