#!/usr/local/bin/perl
use strict;
use warnings;
use Smolder::Dispatch;
use Smolder::Dispatch;
use Smolder::Control;
use Smolder::Control::Admin;
use Smolder::Control::Admin::Developers;
use Smolder::Control::Admin::Projects;
use Smolder::Control::Developer;
use Smolder::Control::Developer::Prefs;
use Smolder::Control::Projects;
use Smolder::Control::Graphs;
use Smolder::Control::Public;
use Smolder::Control::Public::Auth;
use Smolder::Redirect;
use Smolder::Conf qw(Port HostName LogFile HtdocsDir DataDir PidFile);
use Plack::Builder;
builder {
	enable "Plack::Middleware::Static", path => qr{^/(js|style|images)/}, root => HtdocsDir;
	mount '/' => Smolder::Redirect->psgi_app,
	mount '/app' => Smolder::Dispatch->as_psgi
}
