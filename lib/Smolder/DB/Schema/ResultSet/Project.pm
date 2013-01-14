package Smolder::DB::Schema::ResultSet::Project;

use parent 'DBIx::Class::ResultSet';

use Smolder::DBIConn;

=head2 CLASS METHODS

=head3 all_names

Returns an array containing all the names of all existing projects.
Can receive an extra arg that is the id of a project who's name should
not be returned.

=cut

sub all_names {
    my ($class, $id) = @_;
    my $sql = "SELECT NAME FROM project";
    $sql .= " WHERE id != $id" if ($id);
    my $sth = Smolder::DBIConn->dbh()->prepare_cached($sql);
    $sth->execute();
    my @names;
    while (my $row = $sth->fetchrow_arrayref()) {
        push(@names, $row->[0]);
    }
    return @names;
}

1;
