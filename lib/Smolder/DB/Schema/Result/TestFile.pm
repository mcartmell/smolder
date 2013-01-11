use utf8;
package Smolder::DB::Schema::Result::TestFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::TestFile

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<test_file>

=cut

__PACKAGE__->table("test_file");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 project

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 label

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 mute_until

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "project",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "label",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "mute_until",
  { data_type => "integer", is_nullable => 1 },
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

=head2 test_file_comments

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFileComment>

=cut

__PACKAGE__->has_many(
  "test_file_comments",
  "Smolder::DB::Schema::Result::TestFileComment",
  { "foreign.test_file" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 test_file_results

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFileResult>

=cut

__PACKAGE__->has_many(
  "test_file_results",
  "Smolder::DB::Schema::Result::TestFileResult",
  { "foreign.test_file" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 09:16:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rZBT/OFZUbJ2NDt5DBINSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use DateTime;

__PACKAGE__->inflate_column('mute_until', {
		inflate => sub { DateTime->from_epoch(epoch => shift, time_zone => 'local') },
		deflate => sub { shift->epoch },
	});

sub is_muted {
    my ($self) = @_;

    my $mute_until = $self->mute_until;
    my $is_muted = defined($mute_until) && time < $mute_until->epoch;
    return $is_muted;
}

1;
