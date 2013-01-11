use utf8;
package Smolder::DB::Schema::Result::TestFileResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::TestFileResult

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<test_file_result>

=cut

__PACKAGE__->table("test_file_result");

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

=head2 smoke_report

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 file_index

  data_type: 'integer'
  is_nullable: 0

=head2 total

  data_type: 'integer'
  is_nullable: 0

=head2 failed

  data_type: 'integer'
  is_nullable: 0

=head2 percent

  data_type: 'integer'
  is_nullable: 0

=head2 added

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "project",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "test_file",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "smoke_report",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "file_index",
  { data_type => "integer", is_nullable => 0 },
  "total",
  { data_type => "integer", is_nullable => 0 },
  "failed",
  { data_type => "integer", is_nullable => 0 },
  "percent",
  { data_type => "integer", is_nullable => 0 },
  "added",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

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

=head2 smoke_report

Type: belongs_to

Related object: L<Smolder::DB::Schema::Result::SmokeReport>

=cut

__PACKAGE__->belongs_to(
  "smoke_report",
  "Smolder::DB::Schema::Result::SmokeReport",
  { id => "smoke_report" },
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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 15:45:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BGd/GC96wS6T9V4gbo0DEQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use DateTime;

__PACKAGE__->inflate_column('added', {
		inflate => sub { DateTime->from_epoch(epoch => shift, time_zone => 'local') },
		deflate => sub { shift->epoch },
	});

1;
