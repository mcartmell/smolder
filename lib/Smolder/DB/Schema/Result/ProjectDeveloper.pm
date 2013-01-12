use utf8;
package Smolder::DB::Schema::Result::ProjectDeveloper;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::ProjectDeveloper

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<project_developer>

=cut

__PACKAGE__->table("project_developer");

=head1 ACCESSORS

=head2 project

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 developer

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 preference

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 admin

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 added

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "project",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "developer",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "preference",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "admin",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "added",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project>

=item * L</developer>

=back

=cut

__PACKAGE__->set_primary_key("project", "developer");

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

=head2 preference

Type: belongs_to

Related object: L<Smolder::DB::Schema::Result::Preference>

=cut

__PACKAGE__->belongs_to(
  "preference",
  "Smolder::DB::Schema::Result::Preference",
  { id => "preference" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-12 18:42:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aM9MMGf9uyg++znceWluaw

__PACKAGE__->inflate_column('added', {
		inflate => sub { Smolder::DB->parse_datetime(shift) },
		deflate => sub { Smolder::DB->format_datetime(shift) },
	});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
