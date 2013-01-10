use utf8;
package Smolder::DB::Schema::Result::SmokeReportTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::SmokeReportTag

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<smoke_report_tag>

=cut

__PACKAGE__->table("smoke_report_tag");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 smoke_report

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tag

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "smoke_report",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tag",
  { data_type => "text", default_value => "", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 09:16:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hNYCw5RvxuclukzyLt9ulQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
