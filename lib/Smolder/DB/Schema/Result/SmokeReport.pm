use utf8;
package Smolder::DB::Schema::Result::SmokeReport;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Smolder::DB::Schema::Result::SmokeReport

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<smoke_report>

=cut

__PACKAGE__->table("smoke_report");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 project

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 developer

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 added

  data_type: 'text'
  is_nullable: 0

=head2 architecture

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 platform

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=head2 pass

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 fail

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 skip

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 todo

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 todo_pass

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 test_files

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 total

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 comments

  data_type: 'blob'
  default_value: (empty string)
  is_nullable: 1

=head2 invalid

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 invalid_reason

  data_type: 'blob'
  default_value: (empty string)
  is_nullable: 1

=head2 duration

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 purged

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 failed

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 revision

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "project",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "developer",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "added",
  { data_type => "text", is_nullable => 0 },
  "architecture",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "platform",
  { data_type => "text", default_value => "", is_nullable => 1 },
  "pass",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "fail",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "skip",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "todo",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "todo_pass",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "test_files",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "total",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "comments",
  { data_type => "blob", default_value => "", is_nullable => 1 },
  "invalid",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "invalid_reason",
  { data_type => "blob", default_value => "", is_nullable => 1 },
  "duration",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "purged",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "failed",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "revision",
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

=head2 smoke_report_tags

Type: has_many

Related object: L<Smolder::DB::Schema::Result::SmokeReportTag>

=cut

__PACKAGE__->has_many(
  "smoke_report_tags",
  "Smolder::DB::Schema::Result::SmokeReportTag",
  { "foreign.smoke_report" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 test_file_results

Type: has_many

Related object: L<Smolder::DB::Schema::Result::TestFileResult>

=cut

__PACKAGE__->has_many(
  "test_file_results",
  "Smolder::DB::Schema::Result::TestFileResult",
  { "foreign.smoke_report" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-10 15:45:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yw49GZP7ucyNnUtZNO1fZA

__PACKAGE__->inflate_column('added', {
		inflate => sub { Smolder::DB->parse_datetime(shift) },
		deflate => sub { Smolder::DB->format_datetime(shift) },
	});

use Smolder::Conf qw(DataDir TruncateTestFilenames);
use Smolder::Email;
use File::Spec::Functions qw(catdir catfile);
use File::Basename qw(basename);
use File::Path qw(mkpath rmtree);
use File::Copy qw(move copy);
use File::Temp qw(tempdir);
use Cwd qw(fastcwd);
use DateTime;
use Smolder::TAPHTMLMatrix;
use Carp qw(croak);
use TAP::Harness::Archive;
use IO::Zlib;

# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head3 data_dir

The directory in which the data files for this report reside.
If it doesn't exist it will be created.

=cut

sub data_dir {
    my $self = shift;
    my $dir = catdir(DataDir, 'smoke_reports', $self->project->id, $self->id);

    # create it if it doesn't exist
    mkpath($dir) if (!-d $dir);
    return $dir;
}

=head3 file

This returns the file name of where the full report file for this
smoke report does (or will) reside. If the directory does not
yet exist, it will be created.

=cut

sub file {
    my $self = shift;
    return catfile($self->data_dir, 'report.tar.gz');
}

=head3 html

A reference to the HTML text of this Test Report.

=cut

sub html {
    my $self = shift;
    return $self->_slurp_file(catfile($self->data_dir, 'html', 'report.html'));
}

=head3 html_test_detail 

This method will return the HTML for the details of an individual
test file. This is useful when you only need the details for some
of the test files (such as an AJAX request).

It receives one argument, which is the index of the test file to
show.

=cut

sub html_test_detail {
    my ($self, $num) = @_;
    my $file = catfile($self->data_dir, 'html', "$num.html");

    return $self->_slurp_file($file);
}

=head3 tap_stream

This method will return the file name that holds the recorded TAP stream
given the index of that stream.

=cut

sub tap_stream {
    my ($self, $index) = @_;
    return $self->_slurp_file(catfile($self->data_dir, 'tap', "$index.tap"));
}

# just return the file
# TODO - do something else if the file no longer exists
sub _slurp_file {
    my ($self, $file_name) = @_;
    my $text;
    local $/;
    open(my $IN, '<', $file_name)
      or croak "Could not open file '$file_name' for reading! $!";

    $text = <$IN>;
    close($IN)
      or croak "Could not close file '$file_name'! $!";
    return \$text;
}

# This method will send the appropriate email to all developers of this Smoke
# Report's project who requested email notification (through their preferences),
# depending on this report's status.

sub _send_emails {
    my ($self, $results) = @_;

    # setup some stuff for the emails that we only need to do once
#    my $subject =
#      "[" . $self->project->name . "] new " . ($self->failed ? "failed " : '') . "Smolder report";

    my $subject = sprintf("Smolder - [%s] passed %i/%i tests: %s",
                          $self->project->name(),
                          $self->pass(),
                          $self->total(),
                          ( $self->failed() ? "FAILURE" : "SUCCESS" ));

    my $matrix = Smolder::TAPHTMLMatrix->new(
        smoke_report => $self,
        test_results => $results,
    );
    my $tt_params = {
        report  => $self,
        matrix  => $matrix,
        results => $results,
    };

    # get all the developers of this project
    my @devs = $self->project->developers();
    my %sent;
    foreach my $dev (@devs) {

        # get their preference for this project
        my $pref = $dev->project_pref($self->project);

        # skip it, if they don't want to receive it
        next
          if ($pref->email_freq eq 'never'
            or (!$self->failed and $pref->email_freq eq 'on_fail'));

        # see if we need to reset their email_sent_timestamp
        # if we've started a new day
        my $last_sent = $pref->email_sent_timestamp;
        my $now       = DateTime->now(time_zone => 'local');
        my $interval  = $last_sent ? ($now - $last_sent) : undef;

        if (!$interval or ($interval->delta_days >= 1)) {
            $pref->email_sent_timestamp($now);
            $pref->email_sent(0);
            $pref->update;
        }

        # now check to see if we've passed their limit
        next if ($pref->email_limit && $pref->email_sent >= $pref->email_limit);

        # now send the type of email they want to receive
        my $type  = $pref->email_type;
        my $email = $dev->email;
        next if $sent{"$email $type"}++;
        my $error = Smolder::Email->send_mime_mail(
            to        => $email,
            name      => "smoke_report_$type",
            subject   => $subject,
            tt_params => $tt_params,
        );

        warn "Could not send 'smoke_report_$type' email to '$email': $error" if $error;

        # now increment their sent count
        $pref->email_sent($pref->email_sent + 1);
        $pref->update();
    }
}

=head3 delete_files

This method will delete all of the files that can be created and stored in association
with a smoke test report (the 'data_dir' directory). It will C<croak> if the
files can't be deleted for some reason. Returns true if all is good.

=cut

sub delete_files {
    my $self = shift;
    rmtree($self->data_dir);
    $self->update();
    return 1;
}

=head3 summary

Returns a text string summarizing the whole test run.

=cut

sub summary {
    my $self = shift;
    return
      sprintf('%i test cases: %i ok, %i failed, %i todo, %i skipped and %i unexpectedly succeeded',
        $self->total, $self->pass, $self->fail, $self->todo, $self->skip, $self->todo_pass,)
      . ", tags: "
      . join(', ', map { qq("$_") } $self->tags);
}

=head3 total_percentage

Returns the total percentage of passed tests.

=cut

sub total_percentage {
    my $self = shift;
    if ($self->total && $self->failed) {
        return sprintf('%i', (($self->total - $self->failed) / $self->total) * 100);
    } else {
        return 100;
    }
}

=head3 tags

Returns a list of all of tags that have been added to this smoke report.
(in the smoke_report_tag table).

    # returns a simple list of scalars
    my @tags = $report->tags();

=cut

sub tags {
    my ($self, %args) = @_;
		return map { $_->tag } $self->smoke_report_tags;
}

=head3 add_tag

This method will add a tag to a given smoke report

    $report->add_tag('foo');

=cut

sub add_tag {
    my ($self, $tag) = @_;
		$self->create_related('smoke_report_tags', { tag => $tag });
}

=head3 revision_url

Returns a link to this revision in the project's VCS web viewer, if there is one set.

=cut

sub revision_url {
	my $self = shift;
	return unless $self->revision;
	if (my $vcs_url = $self->project->vcs_rev_url) {
		return sprintf($vcs_url, $self->revision);
	}
	return;
}



=head3 delete_tag

This method will remove a tag from a given smoke report

    $report->delete_tag('foo');

=cut

sub delete_tag {
    my ($self, $tag) = @_;
		$self->delete_related('smoke_report_tags', { tag => $tag });
}

sub update_from_tap_archive {
    my ($self, $file) = @_;
    $file ||= $self->file;

    # our data structures for holding the info about the TAP parsing
    my ($duration, @suite_results, @tests, $label);
    my ($total, $failed, $skipped, $planned) = (0, 0, 0, 0);
    my $file_index      = 0;
    my $next_file_index = 0;

    # make our tap directory if it doesn't already exist
    my $tap_dir = catdir($self->data_dir, 'tap');
    unless (-d $tap_dir) {
        mkdir($tap_dir) or die "Could not create directory $tap_dir: $!";
    }

    my $meta;

    # keep track of some things on our own because TAP::Parser::Aggregator
    # doesn't handle total or failed right when a test exits early
    my %suite_data;
    my $aggregator = TAP::Harness::Archive->aggregator_from_archive(
        {
            archive              => $file,
            made_parser_callback => sub {
                my ($parser, $file, $full_path) = @_;
                $label = TruncateTestFilenames ? basename($file) : $file;

                # clear them out for a new run
                @tests = ();
                ($failed, $skipped) = (0, 0, 0);

                # save the raw TAP stream somewhere we can use it later
                $file_index = $next_file_index++;
                my $new_file = catfile($self->data_dir, 'tap', "$file_index.tap");
                copy($full_path, $new_file) or die "Could not copy $full_path to $new_file. $!\n";
            },
            meta_yaml_callback => sub {
                my $yaml = shift;
                $meta     = $yaml->[0];
                $duration = $meta->{stop_time} - $meta->{start_time};
            },
            parser_callbacks => {
                ALL => sub {
                    my $line = shift;
                    if ($line->type eq 'test') {
                        my %details = (
                            ok      => ($line->is_ok     || 0),
                            skip    => ($line->has_skip  || 0),
                            todo    => ($line->has_todo  || 0),
                            comment => ($line->as_string || 0),
                        );
                        $failed++ if !$line->is_ok && !$line->has_skip && !$line->has_todo;
                        $skipped++ if $line->has_skip;
                        push(@tests, \%details);
                    } elsif ($line->type eq 'comment' || $line->type eq 'unknown') {
                        my $slot = $line->type eq 'comment' ? 'comment' : 'uknonwn';

                        # TAP doesn't have an explicit way to associate a comment
                        # with a test (yet) so we'll assume it goes with the last
                        # test. Look backwards through the stack for the last test
                        my $last_test = $tests[-1];
                        if ($last_test) {
                            $last_test->{$slot} ||= '';
                            $last_test->{$slot} .= ("\n" . $line->as_string);
                        }
                    }
                },
                EOF => sub {
                    my $parser = shift;

                    # did we run everything we planned to?
                    my $planned = $parser->tests_planned;
                    my $run     = $parser->tests_run;
                    my $total;
                    if ($planned && $planned > $run) {
                        $total = $planned;
                        foreach (1 .. $planned - $run) {
                            $failed++;
                            push(
                                @tests,
                                {
                                    ok      => 0,
                                    skip    => 0,
                                    todo    => 0,
                                    comment => "test died after test # $run",
                                    died    => 1,
                                }
                            );
                        }
                    } else {
                        $total = $run;
                    }

                    my $percent = $total ? sprintf('%i', (($total - $failed) / $total) * 100) : 100;

                    # record the individual test file and test file result
                    my $test_file = $self->result_source->schema->resultset('TestFile')->find_or_create(
                        {
                            project => $self->project,
                            label   => $label
                        }
                    ) or die "could not find or create test file '$label'";
                    $self->result_source->schema->resultset('TestFileResult')->update_or_create(
                        {
														added				 => Smolder::DB->format_datetime(DateTime->now),
                            test_file    => $test_file->id,
                            smoke_report => $self->id,
                            project      => $self->project->id,
                            total        => $total,
                            failed       => $failed,
                            percent      => $percent,
                            file_index   => $file_index,
                        }
                    ) or die "could not set result for test file '$label'";

                    # push a hash onto the list of results for TAPHTMLMatrix
                    push(
                        @suite_results,
                        {
                            label       => $label,
                            tests       => [@tests],
                            total       => $total,
                            failed      => $failed,
                            percent     => $percent,
                            all_skipped => ($skipped == $total),
                            is_muted    => $test_file->is_muted,
                            mute_until  => $test_file->is_muted
                            ? $test_file->mute_until->strftime("%a %b %d")
                            : '',
                            file_index => $file_index,
                            test_file  => $test_file->id,
                        }
                    );
                    $suite_data{total}  += $total;
                    $suite_data{failed} += $failed;
                  }
            },
        }
    );

    # update
    $self->set_inflated_columns(
			{
        pass       => scalar $aggregator->passed,
        fail       => $suite_data{failed},              # aggregator doesn't calculate these 2 right
        total      => $suite_data{total},
        skip       => scalar $aggregator->skipped,
        todo       => scalar $aggregator->todo,
        todo_pass  => scalar $aggregator->todo_passed,
        test_files => scalar @suite_results,
        failed     => 0 + $aggregator->failed,
        duration   => $duration || '',
			}
    );

    # we can take some things from the meta information in the archive
    # if they weren't provided during the upload
    if ($meta->{extra_properties}) {
        foreach my $k (keys %{$meta->{extra_properties}}) {
            foreach my $field qw(architecture platform comments) {
                if (lc($k) eq $field && !defined $self->$field) {
                    $self->set_inflated_columns({ $field => delete $meta->{extra_properties}->{$k} });
                    last;
                }
            }
        }
    }

    # generate the HTML reports
    my $matrix = Smolder::TAPHTMLMatrix->new(
        smoke_report => $self,
        test_results => \@suite_results,
        meta         => $meta,
    );
    $matrix->generate_html();
    $self->update;

    return \@suite_results;
}

1;
