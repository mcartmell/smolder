=head1 NAME

Smolder::DB::Schema::ResultSet::Developer

=head1 DESCRIPTION

=head1 AUTHOR

mikec

=cut

package Smolder::DB::Schema::ResultSet::Developer;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

use Data::Random qw(rand_chars);

sub get_guest {
    my $pkg = shift;
    my ($guest) = $pkg->search(
			{
				guest    => 1,
        username => 'anonymous',
			}
    );

    unless ($guest) {
        my $fake_pw = join(
            '',
            rand_chars(
                set     => 'alphanumeric',
                min     => 6,
                max     => 8,
                shuffle => 1
            )
        );
        $guest = $pkg->create(
            {
                guest      => 1,
                username   => 'anonymous',
                password   => $fake_pw,
                preference => $pkg->schema->resultset('Preference')->create({email_freq => 'never'}),
            }
        );
    }

    return $guest;
}
	
1;

