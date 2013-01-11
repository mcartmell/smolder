use utf8;
package Smolder::DB::Schema::Result::Developer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::Developer

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<developer>

=cut

__PACKAGE__->table("developer");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 fname

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 lname

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 email

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 password

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 admin

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 preference

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 guest

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "fname",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "lname",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "email",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "password",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "admin",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "preference",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "guest",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username_unique>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username_unique", ["username"]);

=head1 RELATIONS

=head2 preference

Type: belongs_to

Related object: L<Smolder::DB::Schema::Result::Preference>

=cut

__PACKAGE__->belongs_to(
  "preference",
  "Smolder::DB::Schema::Result::Preference",
  { id => "preference" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 project_developers

Type: has_many

Related object: L<Smolder::DB::Schema::Result::ProjectDeveloper>

=cut

__PACKAGE__->has_many(
  "project_developers",
  "Smolder::DB::Schema::Result::ProjectDeveloper",
  { "foreign.developer" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 smoke_reports

Type: has_many

Related object: L<Smolder::DB::Schema::Result::SmokeReport>

=cut

__PACKAGE__->has_many(
  "smoke_reports",
  "Smolder::DB::Schema::Result::SmokeReport",
  { "foreign.developer" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 test_file_comments

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFileComment>

=cut

__PACKAGE__->has_many(
  "test_file_comments",
  "Smolder::DB::Schema::Result::TestFileComment",
  { "foreign.developer" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 17:15:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rrcvwQMvDE5wKexRFNvuzg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->many_to_many(projects => 'project_developers' => 'project');
__PACKAGE__->load_components(qw/EncodedColumn/);
__PACKAGE__->add_columns(
    "password",
    {
        data_type           => "text",
        encode_column       => 1,
        encode_class        => 'Crypt::Eksblowfish::Bcrypt',
        encode_args         => {key_nul => 0, cost => 8},
        encode_check_method => 'check_password'
    }
);


use Data::Random qw(rand_chars);

=head3 full_name

Returns the full name of the Developer, in the following format:

    First Last

=cut

sub full_name {
    my $self = shift;
    return $self->fname . ' ' . $self->lname;
}

=head3 email_hidden

Returns the email address in HTML formatted to foil email harvesting bots.
For example, the email address
    
    test@example.com

Will become

    TODO

=cut

sub email_hidden {
    my $self = shift;

    # TODO - hide somehow
    return $self->email;
}

=head3 groups

Returns the names of the groups this developer is in

=cut

sub groups {
    my $self = shift;
    my @groups;
    push(@groups, 'developer') if !$self->guest;
    push(@groups, 'admin')     if $self->admin;
    return @groups;
}

=head3 project_pref

Given a L<Smolder::DB::Project> object, this returns the L<Smolder::DB::Preference>
object associated with that project and this Developer.

=cut

sub project_pref {
    my ($self, $project) = @_;
		my ($projdev) = $self->project_developers({ project => $project->id });
		return $projdev->preference if $projdev;
		return;
}

=head3 reset_password

Creates a new random password of between 6 and 8 characters suitable and
sets it as this Developer's password. This new password is returned unencrypted.

=cut

sub reset_password {
    my $self = shift;
    my $new_pw = join('', rand_chars(set => 'alphanumeric', min => 6, max => 8, shuffle => 1));
    $self->password($new_pw);
    $self->update();

    return $new_pw;
}

1;
