package Smolder::DB::Schema::ResultSet::SmokeReport;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

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

# exceptions
use Exception::Class (
    'Smolder::Exception::InvalidTAP'     => {description => 'Could not parse TAP files!',},
    'Smolder::Exception::InvalidArchive' => {description => 'Could not unpack file!',},
);

=head3 upload_report

This method will take the name of the uploaded file and the project it's being
added, and various other details and process them. If everything is successful
then the resulting Smolder::DB::SmokeReport object will be returned.

If the given file is compressed, it will be uncompressed before being processed.
After all processing is done, the details file will also be compressed.

It takes the following named arguments

=over

=item file

The full path to the uploaded file.
This is required.

=item project

The L<Smolder::DB::Project> object that this report is being associated with.
This is required.

=item developer

The L<Smolder::DB::Developer> who is uploading this file. If none is given,
then the anonymous guest account will be used.
This is optional.

=item architecture

The architecture this test was run on.
This is optional.

=item platform

The platform this test was run on.
This is optional.

=item comments

Any comments associated with this report.
This is optional.

=back

=cut

sub upload_report {

    # TODO - validate params
    my ($class, %args) = @_;

    my $file    = $args{file};
    my $dev     = $args{developer} ||= Smolder::DB::rs('Developer')->get_guest()->id;
    my $project = $args{project};

    # create our initial report
    my $report = $class->create(
        {
						added				 => DateTime->now,
            developer    => $dev,
            project      => $args{project},
            architecture => ($args{architecture} || ''),
            platform     => ($args{platform} || ''),
            comments     => ($args{comments} || ''),
            revision     => ($args{revision} || ''),
        }
    );

    my $tags = $args{tags} || [];
    $report->add_tag($_) foreach (@$tags);

    my $results = $report->update_from_tap_archive($file);

    # send an email to all the user's who want this report
    $report->_send_emails($results);

    # move the tmp file to it's real destination
    my $dest = $report->file;
    my $out_fh;
    if ($file =~ /\.gz$/ or $file =~ /\.zip$/) {
        open($out_fh, '>', $dest)
          or die "Could not open file $dest for writing:$!";
    } else {

        #compress it if it's not already
        $out_fh = IO::Zlib->new();
        $out_fh->open($dest, 'wb9')
          or die "Could not open file $dest for writing compressed!";
    }

    my $in_fh;
    open($in_fh, $file)
      or die "Could not open file $file for reading! $!";
    my $buffer;
    while (read($in_fh, $buffer, 10240)) {
        print $out_fh $buffer;
    }
    close($in_fh);
    $out_fh->close();

    # purge old reports
    $project->purge_old_reports();

    return $report;
}


=head3 update_all_report_html 

Look at all existing reports in the database and regenerate
the HTML for each of these reports. This is useful for development
and also upgrading when the report HTML template files have changed
and you want that change to propagate.

=cut

sub update_all_report_html {
    my $class = shift;
    my @reports = $class->search(purged => 0);
    foreach my $report (@reports) {
        warn "Updating report #$report\n";
        eval { $report->update_from_tap_archive() };
        warn "  Problem updating report #$report: $@\n" if $@;
    }

}

1;
