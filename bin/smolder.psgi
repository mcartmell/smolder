#!/usr/local/bin/perl
use strict;
use warnings;

# create database if it doesn't exist
BEGIN {
    require Smolder::DB;
    unless (-e Smolder::DB->db_file) {
        Smolder::DB->create_database;
    } else {
        # upgrade if we need to
        require Smolder::Upgrade;
        Smolder::Upgrade->new->upgrade();
    }
}
# preload some modules
use Smolder::Dispatch::PSGI;
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
use Smolder::Upgrade;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Static", path => qr{^/(js|style|images)/}, root => HtdocsDir;
    mount
      '/'          => Smolder::Redirect->psgi_app,
      mount '/app' => Smolder::Dispatch::PSGI->as_psgi;
}
