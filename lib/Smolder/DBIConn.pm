=head1 NAME

Smolder::DBIConn

=head1 DESCRIPTION

=head1 AUTHOR

mikec

=cut

package Smolder::DBIConn;

use strict;
use warnings;

use Exporter qw(import);
our @EXPORT = qw(dbh);
use DBIx::Connector;

my $conn;

sub dbh { instance()->dbh }

sub instance {
	$conn ||= do {
		DBIx::Connector->new(
    "dbi:SQLite:dbname=" . Smolder::DB->db_file(),
    '', '',
    {
        RaiseError         => 1,
        PrintError         => 0,
        Warn               => 0,
        PrintWarn          => 0,
        AutoCommit         => 1,
        FetchHashKeyName   => 'NAME_lc',
        ShowErrorStatement => 1,
        ChopBlanks         => 1,
    }
	);
	};
	return $conn;
}

1;

