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

=head2 vcs_rev_url

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
  "vcs_rev_url",
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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-11 15:06:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ikao+SwdcMSDc6lNpgd5kQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use DateTime;
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

=head3 report_count

The number of reports associated with this Project. Can also provide an
optional tag to use as well

=cut

sub report_count {
    my ($self, $tag) = @_;
    if ($tag) {
			return $self->smoke_reports({ 'smoke_report_tags.smoke_report' => 'smoke_report.id' }, { join => 'smoke_report_tags' })->count;
    } else {
			return $self->smoke_reports->count;
    }
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

=head3 tags

Returns a list of all of tags that have been added to smoke reports for
this project (in the smoke_report_tag table).

    # returns a simple list of scalars
    my @tags = $project->tags();

    # returns a hash of the tag value and count, ie { tag => 'foo', count => 20 }
    my @tags = $project->tags(with_counts => 1);

=cut

sub tags {
    my ($self, %args) = @_;
    my @tags;
		my $dbh = Smolder::DBIConn::dbh();
    if ($args{with_counts}) {
        my $sth = $dbh->prepare_cached(
            q/
            SELECT srt.tag, COUNT(*) FROM smoke_report_tag srt
            JOIN smoke_report sr ON (sr.id = srt.smoke_report)
            WHERE sr.project = ? GROUP BY srt.tag ORDER BY srt.tag/
        );
        $sth->execute($self->id);
        while (my $row = $sth->fetchrow_arrayref()) {
            push(@tags, {tag => $row->[0], count => $row->[1]});
        }
    } else {
        my $sth = $dbh->prepare_cached(
            q/
            SELECT DISTINCT(srt.tag) FROM smoke_report_tag srt 
            JOIN smoke_report sr ON (sr.id = srt.smoke_report) 
            WHERE sr.project = ? ORDER BY srt.tag/
        );
        $sth->execute($self->id);
        while (my $row = $sth->fetchrow_arrayref()) {
            push(@tags, $row->[0]);
        }
    }
    return @tags;
}

=head3 admins 

Returns a list of L<Smolder::DB::Schema::Result::Developer> objects who are considered 'admins'
for this Project

=cut

sub admins {
	my $self = shift;
	return $self->developers({ 'me.admin' => 1 }, {join => 'project_developers'});
}

=head3 is_admin

Returns true if the given L<Smolder::DB::Developer> is considered an 'admin'
for this Project.

    if( $project->is_admin($developer) {
    ...
    }

=cut

sub is_admin {
    my ($self, $developer) = @_;
		my ($dev) = $self->project_developers({ developer => $developer->id });
		return $dev;
}

=head3 clear_admins

Removes the 'admin' flag from any Developers associated with this Project.

=cut

sub clear_admins {
    my ($self, @admins) = @_;
    my $sth;
		my @proj_devs;
    if (@admins) {
			@proj_devs = $self->project_developers( { developer => \@admins });
    } else {
			@proj_devs = $self->project_developers;
    }
		$_->update({ admin => 0 }) for @proj_devs;
}

=head3 set_admins

Given a list of Developer id's, this method will set each Developer
to be an admin of the Project.

=cut

sub set_admins {
    my ($self, @admins) = @_;
		for my $dev ($self->project_developers( { developer => \@admins })) {
			$dev->update({ admin => 1 });
		}
}

=head3 report_graph_data

Will return an array of arrays (based on the given fields) that
is suitable for feeding to GD::Graph. To limit the date range
used to build the data, you can also pass a 'start' and 'stop'
L<DateTime> parameter.

    my $data = $project->report_graph_data(
        fields  => [qw(total pass fail)],
        start   => $start,
        stop    => DateTime->today(),
    );

=cut

#TODO rewrite without sql
sub report_graph_data {
    my ($self, %args) = @_;
    my $fields = $args{fields};
    my $start  = $args{start};
    my $stop   = $args{stop};
    my $tag    = $args{tag};
    my @data;
    my @bind_cols = ($self->id);

    # we need the date before anything else
    my $sql;
    if ($tag) {
        $sql =
            "SELECT "
          . join(', ', "added", @$fields)
          . " FROM smoke_report sr"
          . " JOIN smoke_report_tag srt ON (sr.id = srt.smoke_report)"
          . " WHERE sr.project = ? AND sr.invalid = 0 AND srt.tag = ?";
        push(@bind_cols, $tag);
    } else {
        $sql =
            "SELECT "
          . join(', ', "added", @$fields)
          . " FROM smoke_report sr"
          . " WHERE sr.project = ? AND sr.invalid = 0 ";
    }

    # if we need to limit by date
    if ($start) {
        $sql .= " AND DATE(sr.added) >= ? ";
        push(@bind_cols, $start->strftime('%Y-%m-%d'));
    }
    if ($stop) {
        $sql .= " AND DATE(sr.added) <= ? ";
        push(@bind_cols, $stop->strftime('%Y-%m-%d'));
    }

    # add optional args
    foreach my $extra_param qw(architecture platform) {
        if ($args{$extra_param}) {
            $sql .= " AND sr.$extra_param = ? ";
            push(@bind_cols, $args{$extra_param});
        }
    }

    # add the ORDER BY
    $sql .= " ORDER BY sr.added ";

    my $sth = Smolder::DBIConn::dbh()->prepare_cached($sql);
    $sth->execute(@bind_cols);
    while (my $row = $sth->fetchrow_arrayref()) {

        # reformat added - used to do this in SQL with DATE_FORMAT(),
        # but SQLite don't play that game
        my ($year, $month, $day) = $row->[0] =~ /(\d{4})-(\d{2})-(\d{2})/;
        $row->[0] = "$month/$day/$year";

        for my $i (0 .. scalar(@$row) - 1) {
            push(@{$data[$i]}, $row->[$i]);
        }
    }
    return \@data;
}

=head3 platforms

Returns an arrayref of all the platforms that have been associated with
smoke tests uploaded for this project.

=cut

sub platforms {
    my $self = shift;
    my $sth  = Smolder::DBIConn::dbh()->prepare_cached(
        q(
        SELECT DISTINCT platform FROM smoke_report
        WHERE platform != '' AND project = ? ORDER BY platform
    )
    );
    $sth->execute($self->id);
    my @plats;
    while (my $row = $sth->fetchrow_arrayref) {
        push(@plats, $row->[0]);
    }
    return \@plats;
}

=head3 architectures

Returns a list of all the architectures that have been associated with
smoke tests uploaded for this project.

=cut

sub architectures {
    my $self = shift;
    my $sth  = Smolder::DBIConn::dbh()->prepare_cached(
        q(
        SELECT DISTINCT architecture FROM smoke_report
        WHERE architecture != '' AND project = ? ORDER BY architecture
    )
    );
    $sth->execute($self->id);
    my @archs;
    while (my $row = $sth->fetchrow_arrayref) {
        push(@archs, $row->[0]);
    }
    return \@archs;
}

=head3 graph_start_datetime

Returns a L<DateTime> object that represents the real date for the value
stored in the 'graph_start' column. For example, if the current date
were March 17, 2006 and the project was started on Feb 20th, 2006 
then the following values would become the following dates:

    project => Feb 20th, 2006
    year    => Jan 1st,  2006
    month   => Mar 1st,  2006
    week    => Mar 13th, 2006
    day     => Mar 17th, 2006

=cut

sub graph_start_datetime {
    my $self = shift;
    my $dt;

    # the project's start date
    if ($self->graph_start eq 'project') {
        $dt = $self->start_date;

        # the first day of this year
    } elsif ($self->graph_start eq 'year') {
        $dt = DateTime->today()->set(
            month => 1,
            day   => 1,
        );

        # the first day of this month
    } elsif ($self->graph_start eq 'month') {
        $dt = DateTime->today()->set(day => 1);

        # the first day of this week
    } elsif ($self->graph_start eq 'week') {
        $dt = DateTime->today;
        my $day_diff = $dt->day_of_week - 1;
        $dt->subtract(days => $day_diff) if ($day_diff);

        # today
    } elsif ($self->graph_start eq 'day') {
        $dt = DateTime->today();
    }
    return $dt;
}

=head3 most_recent_report

Returns the most recent L<Smolder::DB::SmokeReport> object that was added.

=cut

sub most_recent_report {
    my $self = shift;
		return $self->smoke_reports(undef, { order_by => { -desc => 'added' }, rows => 1 });
}

1;
