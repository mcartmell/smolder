use utf8;
package Smolder::DB::Schema::Result::TestFileComment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::TestFileComment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<test_file_comment>

=cut

__PACKAGE__->table("test_file_comment");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 project

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 test_file

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 developer

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 added

  data_type: 'integer'
  is_nullable: 0

=head2 comment

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "project",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "test_file",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "developer",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "added",
  { data_type => "integer", is_nullable => 0 },
  "comment",
  { data_type => "text", default_value => "", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 developer

Type: belongs_to

Related object: L<Smolder::DB::Schema::Result::Developer>

=cut

__PACKAGE__->belongs_to(
  "developer",
  "Smolder::DB::Schema::Result::Developer",
  { id => "developer" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 project

Type: belongs_to

Related object: L<Smolder::DB::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "Smolder::DB::Schema::Result::Project",
  { id => "project" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 test_file

Type: belongs_to

Related object: L<Smolder::DB::Schema::Result::TestFile>

=cut

__PACKAGE__->belongs_to(
  "test_file",
  "Smolder::DB::Schema::Result::TestFile",
  { id => "test_file" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 09:16:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AfejeLFru7IneTPUWF7cnw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
