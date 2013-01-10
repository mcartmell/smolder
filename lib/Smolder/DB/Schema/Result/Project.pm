use utf8;
package Smolder::DB::Schema::Result::Project;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::Project

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<project>

=cut

__PACKAGE__->table("project");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 start_date

  data_type: 'integer'
  is_nullable: 0

=head2 public

  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 enable_feed

  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 default_platform

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 default_arch

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 graph_start

  data_type: 'text'
  default_value: 'project'
  is_nullable: 1

=head2 allow_anon

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 max_reports

  data_type: 'integer'
  default_value: 100
  is_nullable: 1

=head2 extra_css

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "start_date",
  { data_type => "integer", is_nullable => 0 },
  "public",
  { data_type => "integer", default_value => 1, is_nullable => 1 },
  "enable_feed",
  { data_type => "integer", default_value => 1, is_nullable => 1 },
  "default_platform",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "default_arch",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "graph_start",
  { data_type => "text", default_value => "project", is_nullable => 1 },
  "allow_anon",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "max_reports",
  { data_type => "integer", default_value => 100, is_nullable => 1 },
  "extra_css",
  { data_type => "text", default_value => "", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_unique>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name_unique", ["name"]);

=head1 RELATIONS

=head2 project_developers

Type: has_many

Related object: L<Smolder::DB::Schema::Result::ProjectDeveloper>

=cut

__PACKAGE__->has_many(
  "project_developers",
  "Smolder::DB::Schema::Result::ProjectDeveloper",
  { "foreign.project" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 smoke_reports

Type: has_many

Related object: L<Smolder::DB::Schema::Result::SmokeReport>

=cut

__PACKAGE__->has_many(
  "smoke_reports",
  "Smolder::DB::Schema::Result::SmokeReport",
  { "foreign.project" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 test_file_comments

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFileComment>

=cut

__PACKAGE__->has_many(
  "test_file_comments",
  "Smolder::DB::Schema::Result::TestFileComment",
  { "foreign.project" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 test_file_results

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFileResult>

=cut

__PACKAGE__->has_many(
  "test_file_results",
  "Smolder::DB::Schema::Result::TestFileResult",
  { "foreign.project" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 test_files

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFile>

=cut

__PACKAGE__->has_many(
  "test_files",
  "Smolder::DB::Schema::Result::TestFile",
  { "foreign.project" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 09:16:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U8oQtutyyjl4qGfKIun1lA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use Smolder::DBIConn;

__PACKAGE__->many_to_many('developers' => 'project_developers' => 'developer');
__PACKAGE__->inflate_column('start_date', {
		inflate => sub { Smolder::DB->parse_datetime(shift) },
		deflate => sub { Smolder::DB->format_datetime(shift) },
	});

=head3 has_developer

Return true if the given L<Smolder::DB::Developer> object is considered a member
of this Project.

    if( ! $project->has_developer($dev) ) {
        return "Unauthorized!";
    }

=cut

sub has_developer {
    my ($self, $developer) = @_;
    my $sth = dbh()->prepare_cached(
        qq(
        SELECT COUNT(*) FROM project_developer
        WHERE project = ? AND developer = ?
    )
    );
    $sth->execute($self->id, $developer->id);
    my $row = $sth->fetchrow_arrayref();
    $sth->finish();
    return $row->[0];
}

=head3 all_reports

Returns a list of L<Smolder::DB::SmokeReport> objects that are associate with this
Project in descending order (by default). You can provide optional 'limit' and 'offset' parameters
which will control which reports (and how many) are returned.

You can additionally specify a 'direction' parameter to specify the order in which they
are returned.

    # all of them
    my @reports = $project->all_reports();

    # just 5 most recent
    @reports = $project->all_reports(
        limit => 5
    );

    # the next 5
    @reports = $project->all_reports(
        limit   => 5,
        offset  => 5,
    );

    # in ascendig order
    @reports = $project->all_reports(
        direction   => 'ASC',
    );

=cut

sub all_reports {
    my ($self, %args) = @_;
    my $limit     = $args{limit}     || 0;
    my $offset    = $args{offset}    || 0;
    my $direction = ($args{direction} && $args{direction} eq 'ASC') ? '-asc' : '-desc';
    my $tag       = $args{tag};

    my $sql;
		my %options = ( order_by => { $direction => 'id' });
		if ($limit) {
			$options{offset} = $offset;
			$options{rows} = $limit;
		}
		my @reports;
    if ($tag) {
			@reports = map { $_->smoke_report } $self->result_source->schema->resultset('SmokeReportTag')->search({ tag => $args{tag}, }, { prefetch => 'smoke_report' });
    } else {
			@reports = $self->smoke_reports(undef, \%options);
    }
		return @reports;
}

=head3 purge_old_reports 

This method will check to see if the C<max_reports> limit has been reached
for this project and delete the tap archive files associated with those
reports, also marking the reports as C<purged>.

=cut

sub purge_old_reports {
    my $self = shift;
    if ($self->max_reports) {

        # Delete any non-purged reports that pass the above limit
				for my $report ($self->smoke_reports(undef, { offset => $self->max_reports, limit => 1_000_000, order_by => { -desc => 'added' } })) {
            $report->delete_files();
            $report->purged(1);
            $report->update();
        }
    }
}

1;
