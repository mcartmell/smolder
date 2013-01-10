package Smolder::DB::SmokeReport;
use strict;
use warnings;
use base 'Smolder::DB';
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
use Smolder::DB::TestFile;
use Smolder::DB::TestFileResult;
use Carp qw(croak);
use TAP::Harness::Archive;
use IO::Zlib;

__PACKAGE__->set_up_table('smoke_report');

# exceptions
use Exception::Class (
    'Smolder::Exception::InvalidTAP'     => {description => 'Could not parse TAP files!',},
    'Smolder::Exception::InvalidArchive' => {description => 'Could not unpack file!',},
);

=head1 NAME

Smolder::DB::SmokeReport

=head1 DESCRIPTION

L<Class::DBI> based model class for the 'smoke_report' table in the database.

=head1 METHODS

=head2 ACCESSSOR/MUTATORS

Each column in the borough table has a method with the same name
that can be used as an accessor and mutator.

The following columns will return objects instead of the value contained in the table:

=cut

__PACKAGE__->has_a(
    added   => 'DateTime',
    inflate => sub { __PACKAGE__->parse_datetime(shift) },
    deflate => sub { __PACKAGE__->format_datetime(shift) },
);
__PACKAGE__->has_a(developer => 'Smolder::DB::Developer');
__PACKAGE__->has_a(project   => 'Smolder::DB::Project');

# when a new object is created, set 'added' to now()
__PACKAGE__->add_trigger(
    before_create => sub {
        my $self = shift;
        $self->_attribute_set(added => DateTime->now(time_zone => 'local'));
    },
);

=over

=item added

A L<DateTime> object representing the datetime stored.

=item developer

The L<Smolder::DB::Developer> object who added this report

=item project

The L<Smolder::DB::Project> object that this report is about

=back

=head2 OBJECT METHODS

=head3 add_tag

This method will add a tag to a given smoke report

    $report->add_tag('foo');

=cut

sub add_tag {
    my ($self, $tag) = @_;
    my $sth = $self->db_Main->prepare_cached(
        q/
        INSERT INTO smoke_report_tag (smoke_report, tag) VALUES (?,?)
    /
    );
    $sth->execute($self->id, $tag);
}

=head3 delete_tag

This method will remove a tag from a given smoke report

    $report->delete_tag('foo');

=cut

sub delete_tag {
    my ($self, $tag) = @_;
    my $sth = $self->db_Main->prepare_cached(
        q/
        DELETE FROM smoke_report_tag WHERE smoke_report = ? AND tag = ?
    /
    );
    $sth->execute($self->id, $tag);
}

=head3 tags

Returns a list of all of tags that have been added to this smoke report.
(in the smoke_report_tag table).

    # returns a simple list of scalars
    my @tags = $report->tags();

=cut

sub tags {
    my ($self, %args) = @_;
    my @tags;
    my $sth = $self->db_Main->prepare_cached(
        q/
        SELECT DISTINCT(srt.tag) FROM smoke_report_tag srt
        WHERE srt.smoke_report = ? ORDER BY srt.tag/
    );
    $sth->execute($self->id);
    my $tags = $sth->fetchall_arrayref([0]);
    return map { $_->[0] } @$tags;
}

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

=head2 CLASS METHODS


1;
