use utf8;
package Smolder::DB::Schema::Result::Preference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::Preference

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<preference>

=cut

__PACKAGE__->table("preference");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 email_type

  data_type: 'text'
  default_value: 'full'
  is_nullable: 1

=head2 email_freq

  data_type: 'text'
  default_value: 'on_new'
  is_nullable: 1

=head2 email_limit

  data_type: 'int'
  default_value: 0
  is_nullable: 1

=head2 email_sent

  data_type: 'int'
  default_value: 0
  is_nullable: 1

=head2 email_sent_timestamp

  data_type: 'text'
  is_nullable: 1

=head2 show_passing

  data_type: 'int'
  default_value: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "email_type",
  { data_type => "text", default_value => "full", is_nullable => 1 },
  "email_freq",
  { data_type => "text", default_value => "on_new", is_nullable => 1 },
  "email_limit",
  { data_type => "int", default_value => 0, is_nullable => 1 },
  "email_sent",
  { data_type => "int", default_value => 0, is_nullable => 1 },
  "email_sent_timestamp",
  { data_type => "text", is_nullable => 1 },
  "show_passing",
  { data_type => "int", default_value => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 developers

Type: has_many

Related object: L<Smolder::DB::Schema::Result::Developer>

=cut

__PACKAGE__->has_many(
  "developers",
  "Smolder::DB::Schema::Result::Developer",
  { "foreign.preference" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_developers

Type: has_many

Related object: L<Smolder::DB::Schema::Result::ProjectDeveloper>

=cut

__PACKAGE__->has_many(
  "project_developers",
  "Smolder::DB::Schema::Result::ProjectDeveloper",
  { "foreign.preference" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 15:45:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:506uUts9lIR0cC1nE92kdg

__PACKAGE__->inflate_column('email_sent_timestamp', {
		inflate => sub { Smolder::DB->parse_datetime(shift) },
		deflate => sub { Smolder::DB->format_datetime(shift) },
	});


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
