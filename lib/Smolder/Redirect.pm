package Smolder::Redirect;
use strict;
use warnings;
use parent 'CGI::Application';

use Smolder::Conf qw( HostName Port );

sub setup {
    my $self = shift;
    $self->run_modes( ['redirect'] );
    $self->start_mode('redirect');
}

sub redirect {
    my $self = shift;
    $self->header_type('redirect');
    $self->header_add( -uri => '/app' );
    return "Redirecting...\n";
}

1;

