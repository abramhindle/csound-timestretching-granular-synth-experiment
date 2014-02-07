#!/usr/bin/env perl
# Copyright (C) 2013 Abram Hindle
#
# This program is free software, you can redistribute it and/or modify it
# under the terms of the Artistic License version 2.0.
#
# This program basically relays web based OSC events to your OSC host!
#
# Send an XMLHTTPRequest full of json of the form:
# { "queue":[
#       ["host","osccommand1","i",100,"f",100.0,"s","what"],
#       ["host","osccommand1","i",100,"f",100.0,"s","what"],
#       ["host","osccommand1","i",100,"f",100.0,"s","what"],
#       ["host","osccommand1","i",100,"f",100.0,"s","what"]
#   ]
# }
# And it will be sent out as an OSC Bundle to your OSC host
#
# To start this webservice just run:
#   hypnotoad -f oscrelay.pl
# or
#   perl oscrelay.pl daemon

use Mojolicious::Lite;
use strict;
use JSON;
use Data::Dumper;
use Net::OpenSoundControl::Client;
my %allowed = map { $_ => $_ } 
    qw( 
          /grain/gkFreq
          /grain/gkFreqRand
          /grain/gkDens
          /grain/gkDur
          /grain/gkPhase
          /grain/gkPhaseMix
);

my %hosts = map { $_ => $_ } (map { sprintf("slave%02d",$_) } (1..64));
my %clients = ();
my @paths = qw( /osc );
my $oschost = "127.0.0.1";
my $oscport = 3666;
{
  sub client {
    my ($host) = @_;
    unless (exists $clients{$host}) {
        $clients{$host} = Net::OpenSoundControl::Client->new(Host => $host, Port => $oscport ) or die "Couldn't make $host $oscport [$@]";

    }
    return $clients{$host};
  }
}

sub oscResponder {
  my $self = shift;
  warn "OSC Responder!";
  my $body = $self->req->body();
  my @elms = ();
  my $code = {};
  eval {
    $code = from_json( $body );
  };
  if ($@) {
    warn $@;
    $code = {};
  }
  my %out = ();#map { $_ => [] } keys %hosts;
  if ($code->{queue}) {
    warn Dumper($code);
    foreach my $elm (@{$code->{queue}}) {
      my ($host,$type,@args) = @$elm;
      if ($allowed{$type} && exists $hosts{$host}) {
        my $command = $allowed{$type};
        $out{$host} ||= [];
        push @{$out{$host}},[$command, @args];
      } else {
        my $err = "Not allowed: [$type]".$allowed{$type};
        warn $err;
        $self->respond_to( any => { data => $err }, status => 200 );
      }
    }
  }
  print Dumper(\%out);
  for my $host (keys %out) {
      my @elms = @{$out{$host}};
      my $client = client($host) or die "Bad client for [$host]";
      client($host)->send(['#bundle', 0,@elms]) if @elms;
  }
  my $state = {"ok"=>"ok"};
  my $str = encode_json($state);
  # do we need some raw crap
  $self->respond_to(any => {data=>$str}, status => 200);
}

foreach my $path (@paths) {
  get $path => sub { oscResponder(@_) };
  post $path => sub { oscResponder(@_) };
}

app->start;
